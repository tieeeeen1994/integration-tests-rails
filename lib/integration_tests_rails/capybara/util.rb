# frozen_string_literal: true

require_relative 'helpers'
require_relative 'tests_controller'

module IntegrationTestsRails
  module Capybara
    # Utilities for Capybara setup and configuration are found here.
    module Util
      class << self
        def configure_webmock
          WebMock.disable_net_connect!(allow_localhost: true)
          log 'WebMock configured to allow localhost connections'
        end

        def ensure_server_ready(context)
          return if @server_ready

          log "Waiting for server on #{::Capybara.app_host.presence || 'localhost'} to start..."
          configuration = IntegrationTestsRails.configuration
          server_retries = configuration.max_server_retries
          server_retries.times do |attempt|
            if configuration.experimental_features
              context.visit('/tests')
            else
              context.visit('/')
            end
            @server_ready = true
            log 'Server is ready!'
            break
          rescue StandardError
            log "Server not ready (attempt #{attempt + 1}/#{server_retries})."
          end
          log "Server did not start after #{server_retries} attempts..." unless @server_ready
        end

        def configure_rspec
          RSpec.configure do |config|
            config.include Dsl, type: :feature
            config.before(:each, type: :feature) do
              ::Capybara.current_driver = ::Capybara.javascript_driver
              IntegrationTestsRails::Capybara::Util.ensure_server_ready(self)
            end

            if IntegrationTestsRails.configuration.experimental_features
              config.include(Helper, type: :feature, unit: true)
            end
          end
        end

        def configure_routes
          return unless IntegrationTestsRails.configuration.experimental_features

          app = Rails.application
          routes = app.routes
          # Use append and let Rails handle finalization automatically
          routes.append do
            get '/tests', to: 'tests#index', as: :tests
          end
          routes.instance_variable_set(:@finalized, false)
          routes.finalize!
          log 'Routes appended.'
        end

        def verbose?
          IntegrationTestsRails.configuration.verbose
        end

        def log(message)
          puts "[CAPYBARA] #{message}" if verbose?
        end
      end
    end
  end
end
