# frozen_string_literal: true

module IntegrationTestsRails
  module Istanbul
    module Util
      class << self
        def configure_rspec
          RSpec.configure do |config|
            config.before(:suite) do
              Instrumenter.instrument_all
              Collector.setup
            end

            config.after(:each, type: :feature) do
              Collector.collect(page)
            end

            config.after(:suite) do
              Collector.generate_report
              Collector.restore_original_files
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
