# frozen_string_literal: true

module IntegrationTestsRails
  module Capybara
    # Configure Capybara to use remote Chrome browser via Cuprite.
    module Remote
      class << self
        def setup
          config = IntegrationTestsRails.configuration
          server_host = config.server_host
          server_port = config.server_port

          ::Capybara.server_host = server_host
          ::Capybara.server_port = server_port
          ::Capybara.default_max_wait_time = config.wait_time
          ::Capybara.app_host = "http://localhost:#{server_port}"
          ::Capybara.server = :puma, {
            Silent: !Util.verbose?,
            Host: server_host,
            Port: server_port,
            Threads: config.puma_threads
          }

          register_driver
          Util.log "Remote Chrome Mode: Test server bound to #{server_host}:#{server_port}"
        end

        private

        def register_driver
          config = IntegrationTestsRails.configuration

          ::Capybara.register_driver(:cuprite) do |app|
            timeout = config.timeout
            options = {
              window_size: config.window_size,
              browser_options: {
                'no-sandbox': nil,
                'disable-dev-shm-usage': nil
              },
              url: config.chrome_url,
              timeout: timeout,
              process_timeout: timeout
            }

            Util.log 'Registered Cuprite driver using remote configuration'
            ::Capybara::Cuprite::Driver.new(app, options)
          end
        end
      end
    end
  end
end
