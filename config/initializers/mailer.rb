Rails.application.config.action_mailer.delivery_method = :smtp

Rails.application.config.action_mailer.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'example.com',
  user_name:            Rails.application.secrets.gmail_address,
  password:             Rails.application.secrets.gmail_password,
  authentication:       'plain',
  enable_starttls_auto: true
}
