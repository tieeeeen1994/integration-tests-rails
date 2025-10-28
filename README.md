# Integration Tests Rails

This gem is designed to facilitate integration testing in Ruby on Rails applications. It provides a streamlined way to configure and run integration tests while capturing coverage data for JavaScript files.

## Tech Stack

- **Ruby on Rails** - The primary framework for building web applications.
- **RSpec** - A testing tool for Ruby, used for writing and executing test cases.
- **Capybara** - A library that helps you test web applications by simulating how a real user would interact with your app.
- **Cuprite** - A Capybara driver that uses Chrome DevTools Protocol.
- **Istanbul** - A JavaScript code coverage tool.

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
rails generate integration_tests_rails:install
```

This will install... WIP.
