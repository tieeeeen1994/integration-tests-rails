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
  gem 'integration_tests_rails'
end
```

Test environment is needed to run integration tests. Development environment is needed to be able to use terminal commands provided by the gem.

After adding the gem, run the following command to install it:

```sh
bundle install
```

After installation, run:

```sh
rails integration_tests_rails:install
```

If you do not have `Yarn` installed, the above command will prompt you to install it. Follow the instructions to complete the installation. Re-run the command after installing `Yarn`.

The generator will do the following:
- Install Instanbul using Yarn.
- Add entries in `.gitignore` to ignore coverage reports and locally installed Istanbul packages.

### Configuration

Since test suites can vary greatly between applications, manual setup of the configuration may vary. It is recommended to create a separate helper file alongside `spec_helper.rb` and `rails_helper.rb`.

```ruby
# spec/capybara_helper.rb

require 'rails_helper'
require 'integration_tests_rails'

IntegrationTestsRails.setup
```

The `IntegrationTestsRails.setup` method accepts an optional block for further customization. Below is an example how to use and contains the default values:

```ruby
IntegrationTestsRails.setup do |config|
  config.chrome_url = nil # Used for remote Chrome instances. Needs remote to be true.
  config.max_server_retries = 1000 # Before running the tests, Cuprite starts a server to communicate with Chrome. This sets the maximum number of retries to connect to that server.
  config.puma_threads = '1:1' # Number of threads for the Puma server used by Cuprite.
  config.remote = false # Whether to use a remote Chrome instance.
  config.server_host = '0.0.0.0' # Host for the Puma server used by Cuprite.
  config.server_port = nil # Port for the Puma server used by Cuprite.
  config.source_dir = 'app/javascript' # Directory containing the JavaScript files to be instrumented.
  config.tests_page_html = DEFAULT_HTML_CONTENT # HTML content used for the test page. More details below.
  config.verbose = false # Whether to enable verbose logging.
  config.wait_time = 5 # Max time in seconds to wait after each request by Capybara to load content.
  config.window_size = [1920, 1080] # Size of the browser window used by Cuprite.
end
```

## Unit Testing JavaScript Code

### Usage

To unit test JavaScript code, the gem will visit a test HTML page. By default, it only renders a complete HTML page that also loads importmap-supporting JavaScript code to set up the environment for testing.

```ruby
DEFAULT_HTML_CONTENT = <<~HTML.squish
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta name="turbo-visit-control" content="reload">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>
      <%= javascript_importmap_tags %>
    </head>
    <body>
    </body>
  </html>
HTML
```

Since vendored JavaScript are not included by default, additional tags may be required to load them. Stylesheets can also be loaded if needed. For example, files can be included as follows:
  - `custom_code.js` file in `app/javascript`
  - `vendor.min.js` file in `app/assets/javascripts/plugins`
  - `app.css` file in `app/assets/stylesheets`
  - `custom.css` file in `app/assets/stylesheets`

```ruby
<<~HTML.squish
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta name="turbo-visit-control" content="reload">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>

      <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>
      <%= stylesheet_link_tag 'custom', "data-turbo-track": "reload" %>

      <%= javascript_importmap_tags %>

      <script type="module">
        import CustomCode from 'custom_code';
        window.CustomCode = CustomCode;
      </script>
    </head>
    <body>
      <%= javascript_include_tag 'plugins/vendor.min' %>
    </body>
  </html>
HTML
```

### Writing Tests

Tests can be written using RSpec and Capybara as follows:

```ruby
require 'capybara_helper'

RSpec.describe 'Custom Code Unit Test', type: :feature, unit: true do
  describe '#doSomething' do
    let(:script) do
      'CustomCode.doSomething();'
    end

    it 'does something' do
      expect(result).to eq('Did something!')
    end
  end
end
```

The `script` component is the JavaScript code that will be executed for the test. The `result` component will contain the return value of the evaluated script. The `script` can accept string or heredoc formats:

```ruby
let(:script) do
  <<~JS
    CustomCode.doSomething();
  JS
end
```

Do note that **the `script` component can execute one statement only**. If multiple statements are needed, consider wrapping them in a function and invoking that function in the `script` component.

```ruby
let(:script) do
  <<~JS
    (() => {
      const value1 = CustomCode.getValue1();
      const value2 = CustomCode.getValue2();
      return CustomCode.combineValues(value1, value2);
    })();
  JS
end
```

There is a `function` component that is the same as the `script` component but `function` automatically wraps the containing JavaScript code in an arrow function and executes it. The above can be rewritten as:

```ruby
let(:function) do
  <<~JS
    const value1 = CustomCode.getValue1();
    const value2 = CustomCode.getValue2();
    return CustomCode.combineValues(value1, value2);
  JS
end
```

The above will successfully execute the three statements and return the value in `result`. However, this can become a problem if the JavaScript code being tested relies on waiting for each statement to complete. In such cases, it is recommended to use an array instead in `script`:

```ruby
let(:script) do
  [
    <<~JS,
      CustomCode.initialize();
      CustomCode.doSomething();
    JS
    'CustomCode.openModal()',
    'CustomCode.closeModal()'
  ]
end
```

In such cases where `script` is an array, the `result` component will contain the return value of the **last statement only**. `function` also supports arrays; each element will be wrapped in an arrow function and executed sequentially.

**Do not use `script` and `function` components as the same time in an example.**

## Integration Testing

Refer to [Cuprite](https://github.com/rubycdp/cuprite) and [Capybara](https://github.com/teamcapybara/capybara). Use them as normally in integration tests.

## JavaScript Coverage Reports

After the tests (successful, failed or cancelled), coverage reports will be generated in `coverage/javascript` by default.

## Example Setups

### Using Docker Desktop

If you want to use the [Alpine Chrome](https://hub.docker.com/r/zenika/alpine-chrome) image, this is definitely possible.

Open Docker Desktop, Settings, Resources then Network. Check the Enable host networking option then Apply.

Your docker compose file may contain this entry:

```yaml
# compose.yml

services:
  chrome:
    image: zenika/alpine-chrome:latest
    network_mode: host
    command: >
      --no-sandbox
      --disable-dev-shm-usage
      --disable-gpu
      --disable-web-security
      --remote-debugging-address=0.0.0.0
      --remote-debugging-port=9222
      --headless
    shm_size: 2gb
```

Setting up the gem:

```ruby
# capybara_helper.rb

IntegrationTestsRails.setup do |config|
  config.chrome_url = 'ws://localhost:9222'
  config.remote = true
  config.server_host = '0.0.0.0'
  config.server_port = 9888
end
```

## Contributing

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes.
5. Submit a pull request describing your changes.
