# frozen_string_literal: true

module IstanbulCupriteRails
  module Capybara
    module Util
      MAX_SERVER_RETRIES = 1000
      WINDOW_SIZE = [1920, 1080].freeze

      class << self
        def configure_webmock
          return unless defined?(WebMock)

          WebMock.disable_net_connect!(allow_localhost: true)
          log 'WebMock configured to allow localhost connections'
        end

        def ensure_server_ready(context)
          return if @server_ready

          log "Waiting for server on #{::Capybara.app_host.presence || 'localhost'} to start..."

          MAX_SERVER_RETRIES.times do |attempt|
            context.visit('/400')
            @server_ready = true
            log 'Server is ready!'
            break
          rescue StandardError
            log "Server not ready (attempt #{attempt + 1}/#{MAX_SERVER_RETRIES})."
          end

          log "Server did not start after #{MAX_SERVER_RETRIES} attempts..." unless @server_ready
        end

        def configure_rspec
          RSpec.configure do |config|
            config.before(:each, type: :feature) do
              ::Capybara.current_driver = ::Capybara.javascript_driver
              IstanbulCupriteRails::Capybara::Util.ensure_server_ready(self)
            end
          end
        end

        def remote?
          ENV['CAPYBARA_REMOTE'].to_s.downcase.in?(['true', '1', 'yes'])
        end

        def verbose?
          ENV['CAPYBARA_LOG'].to_s.downcase.in?(['true', '1', 'yes'])
        end

        def log(message)
          puts "[CAPYBARA] #{message}" if verbose?
        end
      end
    end
  end
end
