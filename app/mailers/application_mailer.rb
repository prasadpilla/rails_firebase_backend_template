class ApplicationMailer < ActionMailer::Base
  default from: 'RailsApp <admin@railsapp.com>', reply_to: 'admin@railsapp.com'
  layout 'mailer'
end
