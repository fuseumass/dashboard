# The main controller for the entire Rails application. For the most
# part the application controller contain all the miscalleous methods
# and or any method that need to be seen throughout the entire application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :auth_user
  before_action :set_raven_context
  before_action :get_event_application_mode
  after_action  :set_access_control_headers
  after_action  :set_extra_headers
  # full: true means that the string searched will look for the match anywhere in the "email" string, and not just the beginning
  autocomplete :university, :name, full: true
  autocomplete :major, :name, full: true
  autocomplete :project, :title, full: true
  autocomplete :user, :email, full: true
  autocomplete :prize, :name, full: true
  autocomplete :prize, :criteria, full: true

  wrap_parameters false

  def get_event_application_mode
    if !FeatureFlag.find_by(name: 'application_mode').nil?
      @event_application_mode = FeatureFlag.find_by(name: 'application_mode').description
    else
      @event_application_mode = 'closed'
    end
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def set_extra_headers
    headers['X-Powered-By'] = 'The FuseUMass Platform <https://platform.hackumass.com>'
    headers['X-Pandas'] = 'red'
    if Rails.env.production?
      headers['Host'] = HackumassWeb::Application::DASHBOARD_URL
    end
  end

  # Automatically re-route user to login except when user is logging in or
  # signing up or hardware api call or event api call
  def auth_user
    redirect_to new_user_session_path unless user_is_authenticated?
  end

  #global variables for feature_flags
  $Applications = 'event_applications'
  $MentorshipRequests = 'mentorship_requests'
  $Projects = 'projects'
  $project_submissions = 'project_submissions'
  $Events = 'events'
  $Prizes = 'prizes'
  $CheckIn = 'check_in'
  $Hardware = 'hardware'
  $Judging = 'judging'

  def check_feature_flag?(feature_flag_name)
    feature_flag = FeatureFlag.find_by(name: feature_flag_name)
    return feature_flag.value || feature_flag.nil?
  end
  helper_method :check_feature_flag?

  def is_feature_enabled(feature_flag_name)
    feature_flag = FeatureFlag.find_by(name: feature_flag_name)
    # Redirect user to index if no feature flag has been found or if it's false
    if !check_feature_flag?(feature_flag_name) and (not current_user.is_admin? or not current_user.is_organizer?)
      redirect_to index_path, notice: "#{feature_flag.display_name} are currently not available. Try again later!"
    end
  end

  def slack_notify_user(user_id, message)
    if !HackumassWeb::Application::SLACK_ENABLED
      return
    end
    bot_access_token = HackumassWeb::Application::SLACKINTEGRATION_BOT_ACCESS_TOKEN
    if not bot_access_token or bot_access_token.length == 0
      puts "No bot access token. Unable to notify #{user_id} with #{message}"
      return false
    end
    puts "Notifying #{user_id} with #{message}"

    target_url = "https://slack.com/api/chat.postMessage"

    uri = URI(target_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request.body = JSON.dump({
      "channel" => user_id,
      "text" => message,
      "as_user" => true
    })
    request.content_type = "application/json"
    request['Authorization'] = 'Bearer ' + bot_access_token

    response = https.request(request)
    puts response.body

  end

  def slack_get_user_email(user_id)
    if !HackumassWeb::Application::SLACK_ENABLED
      return ""
    end
    bot_access_token = HackumassWeb::Application::SLACKINTEGRATION_BOT_ACCESS_TOKEN

    if not bot_access_token or bot_access_token.length == 0
      puts "No bot access token"
      return false
    end
    puts "Getting email of #{user_id}"

    target_url = "https://slack.com/api/users.info"

    uri = URI(target_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    params = { :user => user_id}
    uri.query = URI.encode_www_form( params )

    request = Net::HTTP::Get.new(uri.path)
    request['Authorization'] = 'Bearer ' + bot_access_token

    response = https.request(request)

    res = JSON.parse(response.body)
    puts res
    if res["ok"]
      return res["user"]["profile"]["email"]
    end
  end

  def slack_reassociate_users(user_email = nil, force = false)
    if !HackumassWeb::Application::SLACK_ENABLED
      return -1
    end
    bot_access_token = HackumassWeb::Application::SLACKINTEGRATION_BOT_ACCESS_TOKEN
    if not bot_access_token or bot_access_token.length == 0 
      puts "No bot access token"
      return false
    end
    puts "Getting email and user ids from Slack"


    target_url = "https://slack.com/api/users.list"

    uri = URI(target_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(uri.path)
    request.content_type = "application/json"
    request['Authorization'] = 'Bearer ' + bot_access_token

    response = https.request(request)

    count = 0
    res = JSON.parse(response.body)
    if res["ok"]
      res["members"].each do |member|
        email = member["profile"]["email"]
        if user_email == nil or email == user_email
          slack_id = member["id"]
          user = User.where(:email => email)
          if email != nil and user.length == 1
            if user[0].slack_id == nil or force
              user[0].slack_id = slack_id
              user[0].save
              puts "Associated #{email} with slack id #{slack_id}"
              count += 1
            end
          end
        end
      end
    end
    return count
  end

  protected

  # Additional parameters needed for devise
  def configure_permitted_parameters
    additional_params = %i[first_name last_name type non_transactional_email_consent]
    devise_parameter_sanitizer.permit(:sign_up, keys: additional_params)
    devise_parameter_sanitizer.permit(:account_update, keys: additional_params)
  end

  private

  # This method configure sentry so that is capture the user id of the user being
  # affected and the url that that is causing this problem.
  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  # A helper method for 'auth_user'. This method returns a boolean that checks
  # whether if a user is logging in or signing up or calling a hardware api or
  # event api.
  def user_is_authenticated?
    if user_signed_in?
      return true
    end

    controllers = %w[passwords sessions]
    if controllers.include?(controller_name)
      return true
    end

    paths = [new_user_registration_path, hardware_items_path(:json), events_path(:json)]
    if paths.include?(request.path)
      return true
    end

    false
  end
end
