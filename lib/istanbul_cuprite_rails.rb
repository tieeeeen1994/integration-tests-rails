# frozen_string_literal: true

require_relative 'istanbul_cuprite_rails/version'
require_relative 'istanbul_cuprite_rails/configuration'
require_relative 'istanbul_cuprite_rails/istanbul'
require_relative 'istanbul_cuprite_rails/capybara'
require_relative 'istanbul_cuprite_rails/rspec_integration'

module IstanbulCupriteRails
  class Error < StandardError; end

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

      # Configure Capybara/Cuprite
      Capybara.setup

      # Set up RSpec hooks
      RSpecIntegration.configure_rspec
    end
  end
end
