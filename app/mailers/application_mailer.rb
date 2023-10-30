class ApplicationMailer < ActionMailer::Base
  default from: "#{HackumassWeb::Application::NOREPLY_EMAIL}"
  layout 'mailer'
end
