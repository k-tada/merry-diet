require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MerryDiet
  class Application < Rails::Application
    # app/apis 以下の.rbファイルを対象に追加。
    config.paths.add File.join('app', 'apis'), glob: File.join('**', '*.rb')

    # app/apis 以下のファイルをオートロード対象に追加
    config.autoload_paths += Dir[Rails.root.join('app', 'apis', '*')]

    # JBuilder用のViewパスを追加
    config.middleware.use(Rack::Config) do |env|
      env['api.tilt.root'] = Rails.root.join 'app', 'views', 'apis'
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
