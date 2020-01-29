# The main controller for the entire Rails application. For the most
# part the application controller contain all the miscalleous methods
# and or any method that need to be seen throughout the entire application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :auth_user
  before_action :set_raven_context
  after_action  :set_access_control_headers
  after_action  :set_extra_headers
  # full: true means that the string searched will look for the match anywhere in the "email" string, and not just the beginning
  autocomplete :university, :name, full: true
  autocomplete :major, :name, full: true
  autocomplete :user, :email, full: true
  autocomplete :prize, :name, full: true


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
    bot_accesstok = HackumassWeb::Application::SLACKINTEGRATION_BOT_ACCESS_TOKEN
    if not bot_accesstok or bot_accesstok.length == 0
      puts "No bot access token. Unable to notify #{user_id} with #{message}"
      return false
    end
    puts "Notifying #{user_id} with #{message}"

    uri = URI.parse("https://slack.com/api/chat.postMessage")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{bot_accesstok}"
    request.body = JSON.dump({
      "channel" => user_id,
      "text" => message,
      "as_user" => true
    })
    puts request

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    puts response.body

  end

  def slack_get_user_email(user_id)
    bot_accesstok = HackumassWeb::Application::SLACKINTEGRATION_BOT_ACCESS_TOKEN
    if not bot_accesstok or bot_accesstok.length == 0
      puts "No bot access token"
      return false
    end
    puts "Getting email of #{user_id}"

    uri = URI.parse("https://slack.com/api/users.info?token=#{bot_accesstok}&user=#{user_id}")
    request = Net::HTTP::Get.new(uri)
    puts request

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    res = JSON.parse(response.body)
    puts res
    if res["ok"]
      return res["user"]["profile"]["email"]
    end
  end

  def slack_reassociate_users(user_email = nil, force = false)
    bot_accesstok = HackumassWeb::Application::SLACKINTEGRATION_BOT_ACCESS_TOKEN
    if not bot_accesstok or bot_accesstok.length == 0
      puts "No bot access token"
      return false
    end
    puts "Getting email and user ids from Slack"

    uri = URI.parse("https://slack.com/api/users.list?token=#{bot_accesstok}")
    request = Net::HTTP::Get.new(uri)
    puts request

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

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
    additional_params = %i[first_name last_name type]
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
    controllers = %w[passwords sessions]
    paths = [new_user_registration_path, hardware_items_path(:json), events_path(:json)]
    user_signed_in? || controllers.include?(controller_name) || paths.include?(request.path)
  end
end
