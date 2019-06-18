class ApplicationMailer < ActionMailer::Base
  default from: "#{HackumassWeb::Application::DONOTREPLY}"
  layout 'mailer'
end
