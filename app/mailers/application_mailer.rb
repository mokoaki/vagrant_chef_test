class ApplicationMailer < ActionMailer::Base
  default({from: Rails.application.secrets.gmail_address})
  layout 'mailer'
end
