# frozen_string_literal: true

require_relative 'helpers'

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

          config = IntegrationTestsRails.configuration
          log "Waiting for server on #{::Capybara.app_host.presence || 'localhost'} to start..."

          server_retries = config.max_server_retries
          server_retries.times do |attempt|
            context.visit('/400')
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
            config.before(:each, type: :feature) do
              ::Capybara.current_driver = ::Capybara.javascript_driver
              IntegrationTestsRails::Capybara::Util.ensure_server_ready(self)
            end

            config.include(Helper, type: :feature, unit: true)
          end
        end

        def configure_routes
          Rails.application.routes.draw do
            resources :tests, only: :index
          end
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
