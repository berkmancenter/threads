# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Threads
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Hanoi'
    config.active_record.default_timezone = :utc

    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework :rspec, view_specs: false,
                               helper_specs: false,
                               routing_specs: false,
                               intergration_pool: false,
                               fixture: true

      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.formatter = config.log_formatter
      config.log_tags  = [:subdomain, :uuid]
      config.logger    = ActiveSupport::TaggedLogging.new(logger)
    end

    config.active_job.queue_adapter = :sidekiq
  end
end
