require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative '../lib/env_settings'
require_relative '../lib/import/bamru'
require_relative '../lib/ext/string'
require_relative '../lib/ext/kernel'
require_relative '../lib/ext/ar_proxy'

module ListCall
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    dirs = %w(api assets contexts databots decorators forms msgs queries services validators values zrun)
    dirs.each do |directory|
      config.autoload_paths += %W(#{config.root}/app/#{directory})
    end
  end
end
