class ApplicationMailer < ActionMailer::Base
  default from: "#{HackumassWeb::Application::CONTACT_EMAIL}"
  layout 'mailer'
end
