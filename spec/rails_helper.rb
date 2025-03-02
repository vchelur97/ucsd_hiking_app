# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'ostruct'
require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'webmock/rspec'
require 'capybara/rspec'
require 'selenium/webdriver'
require 'database_cleaner/active_record'

# Configure Capybara
Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1280,1024')
  options.add_argument('--disable-dev-shm-usage')
  # options.add_argument('--no-sandbox')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :headless_chrome
Capybara.default_max_wait_time = 5
Capybara.server = :puma, { Silent: true } # Added to ensure Puma is used

# Configure OmniAuth for testing
OmniAuth.config.test_mode = true

# Add additional requires below this line. Rails is not loaded until this point!
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

module TurboHelpers
  def wait_for_turbo
    has_css?("turbo-frame, [data-turbo-frame]", wait: 5) # Adjust timeout as needed
    sleep(0.1) # Small additional wait for any JS to execute
  end

  # Helper for waiting for a specific element with better error messages
  # Update your wait_for_element method to handle text parameter
  def wait_for_element(selector, text: nil, timeout: 5)
    start_time = Time.now

    if text
      sleep(0.1) until has_css?(selector, text: text, wait: 0.1) || (Time.now - start_time > timeout)
      return if has_css?(selector, text: text, wait: 0.1)

      raise Capybara::ElementNotFound, "Waited #{timeout} seconds but couldn't find '#{selector}' with text '#{text}'"
    else
      sleep(0.1) until has_css?(selector, wait: 0.1) || (Time.now - start_time > timeout)
      return if has_css?(selector, wait: 0.1)

      raise Capybara::ElementNotFound, "Waited #{timeout} seconds but couldn't find '#{selector}'"
    end
  end
end

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  config.use_transactional_fixtures = false

  # Include Factory Bot methods
  config.include FactoryBot::Syntax::Methods

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!

  # Configure WebMock
  WebMock.disable_net_connect!(allow_localhost: true)

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :headless_chrome
  end

  config.include TurboHelpers, type: :feature

  config.before(:suite) do
    FileUtils.mkdir_p('tmp/screenshots')
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    stub_request(:get, "https://maps.google.com/leopoldo")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'maps.google.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: "", headers: {})
  end

  # Configure shoulda-matchers
  Shoulda::Matchers.configure do |conf|
    conf.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  config.after(:each, type: :feature, js: true) do |example|
    if example.exception
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      screenshot_path = "tmp/screenshots/#{example.full_description.parameterize}_#{timestamp}.png"
      page.save_screenshot(screenshot_path)
      puts "\nScreenshot saved to #{screenshot_path}"

      # Print HTML of page for debugging
      html_path = "tmp/screenshots/#{example.full_description.parameterize}_#{timestamp}.html"
      File.write(html_path, page.html)
      puts "Page HTML saved to #{html_path}"
    end
  end
end
