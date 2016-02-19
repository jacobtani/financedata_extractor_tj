require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module FinancedataExtractor
  class Application < Rails::Application

    config.active_record.raise_in_transactional_callbacks = true
    config.stock = ['SPK.NZ', 'YHOO', 'HOH16.NYM', 'RBH16.NYM', 'HGG16.CMX', 'GCG16.CMX','PAG16.NYM', 'PLH16.NYM', 'SIG16.CMX']
    config.assets.compile= true

  end
end
