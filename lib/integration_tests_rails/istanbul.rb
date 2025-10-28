# frozen_string_literal: true

require_relative 'istanbul/instrumenter'
require_relative 'istanbul/collector'
require_relative 'istanbul/util'

module IntegrationTestsRails
  module Istanbul
    class << self
      def setup
        Util.configure_rspec
      end
    end

    # Ensure cleanup at exit
    at_exit do
      Collector.restore_original_files
    rescue StandardError => e
      warn "Istanbul cleanup failed: #{e.message}"
    end
  end
end
