# frozen_string_literal: true

if Rails.env.staging? || Rails.env.production?
  unless defined?(SMTP_SETTINGS)
    SMTP_SETTINGS = {
    address: ENV['SMTP_ADDRESS'],
    authentication: :plain,
    enable_starttls_auto: false,
    domain: ENV['SMTP_DOMAIN'],
    password: ENV['SMTP_PASSWORD'],
    port: ENV['SMTP_PORT'],
    user_name: ENV['SMTP_USERNAME']
    }.freeze
  end

  Rails.application.config.action_mailer.smtp_settings = SMTP_SETTINGS
end
