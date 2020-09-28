require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Journal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.active_job.queue_adapter = :delayed_job
    config.action_dispatch.return_only_media_type_on_content_type = false

    config.serve_static_assets = true

    config.time_zone = "Kolkata"
    config.active_record.default_timezone = "Kolkata"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
