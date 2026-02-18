# frozen_string_literal: true

require_relative 'istanbul/instrumenter'
require_relative 'istanbul/collector'
require_relative 'istanbul/util'

module IntegrationTestsRails
  # This contains the Istanbul setup and configuration.
  module Istanbul
    class << self
      def setup
        if IntegrationTestsRails.configuration.js_coverage
          Util.configure_rspec
        else
          Util.log('JS coverage is disabled, skipping Istanbul setup.')
        end
      end
    end

    # Ensure cleanup at exit, either success, failure or cancellation.
    at_exit do
      if IntegrationTestsRails.configuration.js_coverage
        Collector.generate_report
        Collector.restore_original_files
      else
        Util.log('JS coverage is disabled, skipping Istanbul cleanup.')
      end
    rescue StandardError => e
      warn "Istanbul cleanup failed: #{e.message}"
    end
  end
end
