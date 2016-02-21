ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"
require "minitest/rails/capybara"
require 'test_helpers/custom_matchers.rb'

if ENV['SQL'] then ActiveRecord::Base.logger = Logger.new(STDOUT) if defined? ActiveRecord::Base end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include Capybara::DSL
  include Capybara::Assertions

# Test Helper methods
  setup do
    SiteConfig.create(
      running_start: false,
      running_end: true
    )
  end
 
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

  def json_response
    @json_response ||= JSON.parse(response.body)
  end
end