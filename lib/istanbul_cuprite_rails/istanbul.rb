# frozen_string_literal: true

require_relative 'istanbul/instrumenter'
require_relative 'istanbul/collector'
require_relative 'istanbul/util'

module IstanbulCupriteRails
  module Istanbul
    class << self
      def setup
        Instrumenter.instrument_all
        Collector.setup
      end

      def collect(page)
        Collector.collect(page)
      end

      def teardown
        Collector.generate_report
        Collector.restore_original_files
      end
    end
  end
end
