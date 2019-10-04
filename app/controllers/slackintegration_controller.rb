require 'net/http'
require 'uri'
require 'json'

class SlackintegrationController < ApplicationController
  skip_before_action :auth_user, :only => [:index]
  def index
    puts params
    hackathonname = "#{HackumassWeb::Application::HACKATHON_NAME} #{HackumassWeb::Application::HACKATHON_VERSION}"
    integ_token = HackumassWeb::Application::SLACKINTEGRATION_TOKEN
    if not integ_token or integ_token.length == 0
      render json: { "error" => "no_token" }
    elsif params[:token] != integ_token
      render json: { "error" => "invalid_token" }
    elsif params[:type] == 'url_verification'
      render json: { "challenge" => params[:challenge] }
    elsif params[:type] == 'event_callback'
      if params[:event][:type] == 'team_join'
        user_id = params[:event][:user][:id]
        email = slack_get_user_email(user_id)
        user = User.where(:email => email)
        if email == nil or email.length == 0
          render json: { "error" => "no email for id" }
        elsif user.exists?
          puts "Team join user exists"
          user[0].slack_id = user_id
          user[0].save
          slack_notify_user(params[:event][:user][:id], "Hi there #{user[0].first_name} #{user[0].last_name}. Congrats, you've successfully joined the #{hackathonname} Slack! Head back to #{HackumassWeb::Application::DASHBOARD_URL} for more event logistics, or join some relevant channels here!")
          render json: { "ok" => "saved_user" }
        else
          slack_notify_user(params[:event][:user][:id], "Hey there, we weren't able to link your Slack account with the #{hackathonname} Dashboard -- #{email} isn't registered for any accounts in our system. Make sure that you entered the same email address that you used to apply to the event while creating your Slack account.")
          render json: { "ok" => "no_user" }
        end
      else
        render json: { "error" => "unknown" }
      end
    else
      render json: { "error" => "unknown" }
    end
  end
end
