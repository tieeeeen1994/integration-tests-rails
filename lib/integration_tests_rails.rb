# frozen_string_literal: true

require_relative 'integration_tests_rails/version'
require_relative 'integration_tests_rails/railtie'

return unless Rails.env.test? && defined?(RSpec) && defined?(Capybara) && defined?(Cuprite)

require_relative 'integration_tests_rails/configuration'
require_relative 'integration_tests_rails/istanbul'
require_relative 'integration_tests_rails/capybara'

# The main module for the IntegrationTestsRails gem.
module IntegrationTestsRails
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end

    # Convenience method to set up everything at once
    def setup
      yield(configuration) if block_given?

      Capybara.setup
      Istanbul.setup
    end
  end
end
