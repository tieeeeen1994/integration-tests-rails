# frozen_string_literal: true

module IstanbulCupriteRails
  module Capybara
    module Remote
      PUMA_THREADS = '1:1'
      DEFAULT_PORT = 9888
      SERVER_HOST = '0.0.0.0' # rubocop:disable Style/IpAddresses
      TIMEOUT = 30

      class << self
        def setup(wait_time:, chrome_url:)
          port = ENV.fetch('CAPYBARA_PORT', DEFAULT_PORT).to_i

          ::Capybara.server_host = SERVER_HOST
          ::Capybara.server_port = port
          ::Capybara.default_max_wait_time = wait_time
          ::Capybara.app_host = "http://localhost:#{port}"
          ::Capybara.server = :puma, {
            Silent: !Util.verbose?,
            Host: SERVER_HOST,
            Port: port,
            Threads: PUMA_THREADS
          }

          register_driver(chrome_url)
          Util.log "Remote Chrome Mode: Test server bound to #{SERVER_HOST}:#{port}"
        end

        private

        def register_driver(chrome_url)
          ::Capybara.register_driver(:cuprite) do |app|
            options = {
              window_size: Util::WINDOW_SIZE,
              url: chrome_url,
              timeout: TIMEOUT,
              process_timeout: TIMEOUT
            }

            Util.log 'Registered Cuprite driver using remote configuration'
            ::Capybara::Cuprite::Driver.new(app, options)
          end
        end
      end
    end
  end
end
