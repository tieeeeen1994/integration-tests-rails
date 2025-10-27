# frozen_string_literal: true

module IstanbulCupriteRails
  module Capybara
    module Remote
      class << self
        def setup
          config = IstanbulCupriteRails.configuration

          ::Capybara.server_host = config.server_host
          ::Capybara.server_port = config.server_port
          ::Capybara.default_max_wait_time = config.wait_time
          ::Capybara.app_host = "http://localhost:#{config.server_port}"
          ::Capybara.server = :puma, {
            Silent: !Util.verbose?,
            Host: config.server_host,
            Port: config.server_port,
            Threads: config.puma_threads
          }

          register_driver
          Util.log "Remote Chrome Mode: Test server bound to #{config.server_host}:#{config.server_port}"
        end

        private

        def register_driver
          config = IstanbulCupriteRails.configuration

          ::Capybara.register_driver(:cuprite) do |app|
            options = {
              window_size: config.window_size,
              url: config.chrome_url,
              timeout: config.timeout,
              process_timeout: config.timeout
            }

            Util.log 'Registered Cuprite driver using remote configuration'
            ::Capybara::Cuprite::Driver.new(app, options)
          end
        end
      end
    end
  end
end
