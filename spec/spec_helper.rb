# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
# require 'ci/reporter/rake/rspec'     # use this if you're using RSpec
# require "selenium-webdriver"
# require 'capybara/rails'
# require 'capybara/rspec'



# caps = Selenium::WebDriver::Remote::Capabilities.chrome
# # caps.version = "8"
# caps.platform = :WINDOWS

# Capybara.server_port = 3010
Capybara.default_driver = :selenium


# Capybara remote run
require 'system/getifaddrs'

# # init ip
host = "10.242.1.187"
port = "4444"
ip = System.get_ifaddrs.find{ |socket| socket[1][:inet_addr] != "127.0.0.1" } [1][:inet_addr]

Capybara.app_host = "http://#{ip}:#{Capybara.server_port}"
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    :browser => :remote,
    :url => "http://#{host}:#{port}/wd/hub",
    :desired_capabilities => caps
    )
end

# Capybara local run
# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, :browser => :chrome)
# end

# require 'capybara/poltergeist'
# Capybara.default_driver = :poltergeist
# Capybara.javascript_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Capybara::RSpecMatchers
  config.include Capybara::DSL
  config.include Rails.application.routes.url_helpers

  config.after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
