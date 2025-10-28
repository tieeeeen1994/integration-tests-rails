# Integration Tests Rails

This gem is designed to facilitate integration testing in Ruby on Rails applications. It provides a streamlined way to configure and run integration tests while capturing coverage data for JavaScript files.

## Tech Stack

- **Ruby on Rails** - The primary framework for building web applications.
- **RSpec** - A testing tool for Ruby, used for writing and executing test cases.
- **Capybara** - A library that helps you test web applications by simulating how a real user would interact with your app.
- **Cuprite** - A Capybara driver that uses Chrome DevTools Protocol.
- **Istanbul** - A JavaScript code coverage tool.
- **Puma** - A concurrent web server.

## Getting Started

### Installation

Add this line to your Rails application's Gemfile:

```ruby
group :development, :test do
  gem 'integration_tests_rails', require: false
end
```

Test environment is needed to run integration tests. Development environment is needed to be able to use terminal commands provided by the gem.

After adding the gem, run the following command to install it:

```sh
bundle install
```

After installation, run:

```sh
rails generate integration_tests_rails:install
```

If you do not have `Yarn` installed, the above command will prompt you to install it. Follow the instructions to complete the installation. Re-run the command after installing `Yarn`.

The generator will do the following:
- Install Instanbul using Yarn.
- Create a controller that can be used to *unit test JavaScript code*.
- Add a line in `routes.rb` to route requests to the above controller.
- Add an entry in `.gitignore` to ignore coverage reports and locally installed Istanbul packages.

### Configuration

Since test suites can vary greatly between applications, manual setup of the configuration may vary. It is recommended to create a separate helper file alongside `spec_helper.rb` and `rails_helper.rb`.

```ruby
# spec/capybara_helper.rb

require 'integration_tests_rails'

IntegrationTestsRails.setup

require_relative 'features/tests_controller' # Loads the controller for unit testing JavaScript.
```

The `IntegrationTestsRails.setup` method accepts an optional block for further customization. Below is an example how to use and contains the default values:

```ruby
IntegrationTestsRails.setup do |config|
  config.backup_dir = 'tmp/js_backup' # Directory to store the original JavaScript files.
  config.chrome_url = nil # Used for remote Chrome instances. Needs remote to be true.
  config.coverage_path = 'coverage/nyc' # Directory to store coverage reports.
  config.max_server_retries = 1000 # Before running the tests, Cuprite starts a server to communicate with Chrome. This sets the maximum number of retries to connect to that server.
  config.output_dir = 'tmp/instrumented_js' # Directory to store instrumented JavaScript files.
  config.puma_threads = '1:1' # Number of threads for the Puma server used by Cuprite.
  config.remote = false # Whether to use a remote Chrome instance.
  config.server_host = '0.0.0.0' # Host for the Puma server used by Cuprite.
  config.server_port = nil # Port for the Puma server used by Cuprite.
  config.source_dir = 'app/javascript' # Directory containing the JavaScript files to be instrumented.
  config.timeout = 30 # Timeout in seconds for processing requests to the Puma server.
  config.verbose = false # Whether to enable verbose logging.
  config.wait_time = 5 # Max time in seconds to wait after each request by Capybara to load content.
  config.window_size = [1920, 1080] # Size of the browser window used by Cuprite.
end
```
