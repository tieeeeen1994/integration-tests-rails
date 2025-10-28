# frozen_string_literal: true

module IntegrationTestsRails
  module Capybara
    module Local
      class << self
        def setup
          config = IntegrationTestsRails.configuration

          ::Capybara.default_max_wait_time = config.wait_time
          ::Capybara.server = :puma, { Silent: !Util.verbose? }

          register_driver
          Util.log 'Local Chrome Mode: Server is running locally'
        end

        private

        def register_driver
          config = IntegrationTestsRails.configuration

          ::Capybara.register_driver(:cuprite) do |app|
            options = {
              window_size: config.window_size,
              browser_options: {
                'no-sandbox' => nil,
                'disable-dev-shm-usage' => nil,
                'disable-web-security' => nil,
                'disable-gpu' => nil
              }
            }

            Util.log 'Registered Cuprite driver using local configuration'
            ::Capybara::Cuprite::Driver.new(app, options)
          end
        end
      end
    end
  end
end
