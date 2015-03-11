class ApplicationMailer < ActionMailer::Base
  default from: ENV['PRIMARY_EMAIL']
  layout 'mailer'
end
