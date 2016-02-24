require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module FinancedataExtractor
  class Application < Rails::Application
    config.time_zone = 'Auckland'
    config.active_record.default_timezone = :local
    config.active_record.raise_in_transactional_callbacks = true
    config.assets.compile= true
  end
end
