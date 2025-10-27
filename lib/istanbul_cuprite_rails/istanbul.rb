# frozen_string_literal: true

require_relative 'istanbul/instrumenter'
require_relative 'istanbul/collector'

module IstanbulCupriteRails
  module Istanbul
    class << self
      def setup
        Instrumenter.instrument_all
        Collector.setup
      end

      delegate :collect, to: :Collector

      def teardown
        Collector.generate_report
        Collector.restore_original_files
      end
    end
  end
end
