puts "loading support/web_testing.rb"

RSpec.configure do |config|
  config.include Capybara::RSpecMatchers
  config.include Capybara::DSL
  config.include Rails.application.routes.url_helpers

  # use default driver on all tests
  # config.after do
  #   Capybara.reset_sessions!
  #   Capybara.use_default_driver
  # end

  # TESTING SUITE
  FileUtils.rm_rf($base_screenshot_dir)
  FileUtils.rm_f($base_html_path)

  config.before(:each) do
    example.metadata[:id] = @example_number
    FileUtils.mkdir_p(path_to_tmp(example)) unless File.exists?(path_to_tmp(example))    
  end

  config.after(:each) do
    result_name = example.exception ? "failure" : "final"

    save_snapshot(example,result_name)
  end
  # END TESTING SUITE
end
