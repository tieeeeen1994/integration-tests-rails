# frozen_string_literal: true

module IstanbulCupriteRails
  module Capybara
    module Util
      class << self
        def configure_webmock
          WebMock.disable_net_connect!(allow_localhost: true)
          log 'WebMock configured to allow localhost connections'
        end

        def ensure_server_ready(context)
          return if @server_ready

          config = IstanbulCupriteRails.configuration
          log "Waiting for server on #{::Capybara.app_host.presence || 'localhost'} to start..."

          config.max_server_retries.times do |attempt|
            context.visit('/400')
            @server_ready = true
            log 'Server is ready!'
            break
          rescue StandardError
            log "Server not ready (attempt #{attempt + 1}/#{config.max_server_retries})."
          end

          log "Server did not start after #{config.max_server_retries} attempts..." unless @server_ready
        end

        def configure_rspec
          RSpec.configure do |config|
            config.before(:each, type: :feature) do
              ::Capybara.current_driver = ::Capybara.javascript_driver
              IstanbulCupriteRails::Capybara::Util.ensure_server_ready(self)
            end
          end
        end

        def verbose?
          IstanbulCupriteRails.configuration.verbose
        end

        def log(message)
          puts "[CAPYBARA] #{message}" if verbose?
        end
      end
    end
  end
end
