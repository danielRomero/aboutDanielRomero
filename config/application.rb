require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

LOCALES = ['es', 'en']
AVATARS = ['https://media.licdn.com/mpr/mpr/shrink_200_200/p/1/005/0a7/228/39fddd5.jpg', 'https://pbs.twimg.com/profile_images/485074599739019264/hSHRCnH2.jpeg']
LAST_MOD_SITEMAP=DateTime.parse('11/3/2015').utc

module Danielromero
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Madrid'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :es

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.action_mailer.perform_deliveries = true

    # config.action_mailer.delivery_method = :smtp

    config.action_mailer.default_url_options = { host: ENV['HOST'] }
    config.action_mailer.default :charset => "utf-8"
    # config.action_mailer.smtp_settings = {
    #   :address   => ENV['SMTP_ADDRESS'],
    #   :port      => ENV['SMTP_PORT'],
    #   :enable_starttls_auto => true,
    #   :user_name => ENV['SMTP_USERNAME'],
    #   :password  => ENV['SMTP_PASSWORD'],
    #   :authentication => 'login',
    #   :domain => ENV['HOST'],
    # }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :authentication => :plain,
      :address => ENV['SMTP_ADDRESS'],
      :port => 587,
      :domain => ENV['SMTP_DOMAIN'],
      :user_name => ENV['SMTP_USERNAME'],
      :password => ENV['SMTP_PASSWORD']
    }
  end
end
