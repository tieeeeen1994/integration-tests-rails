# frozen_string_literal: true

require_relative 'istanbul/instrumenter'
require_relative 'istanbul/collector'
require_relative 'istanbul/util'

module IntegrationTestsRails
  # This contains the Istanbul setup and configuration.
  module Istanbul
    class << self
      def setup
        Util.configure_rspec
      end
    end

    # Ensure cleanup at exit, either success, failure or cancellation.
    at_exit do
      Collector.generate_report
      Collector.restore_original_files
    rescue StandardError => e
      warn "Istanbul cleanup failed: #{e.message}"
    end
  end
end
