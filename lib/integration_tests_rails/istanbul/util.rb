# frozen_string_literal: true

module IntegrationTestsRails
  module Istanbul
    # Utilities for Istanbul setup and configuration are found here.
    module Util
      class << self
        def configure_rspec
          RSpec.configure do |config|
            config.before(:suite) do
              Collector.setup
            end

            config.after(:each, type: :feature) do
              Collector.collect(page)
            end
          end
        end

        def log(message)
          return unless verbose?

          puts "[ISTANBUL] #{message}"
        end

        private

        def verbose?
          IntegrationTestsRails.configuration&.verbose
        end
      end
    end
  end
end
