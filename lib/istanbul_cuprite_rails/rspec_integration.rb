# frozen_string_literal: true

module IstanbulCupriteRails
  module RSpecIntegration
    class << self
      def configure_rspec
        RSpec.configure do |config|
          config.before(:suite) do
            IstanbulCupriteRails::Istanbul.setup
          end

          config.after(:each, type: :feature) do
            IstanbulCupriteRails::Istanbul.collect(page)
          end

          config.after(:suite) do
            IstanbulCupriteRails::Istanbul.teardown
          end
        end

        # Ensure cleanup at exit
        at_exit do
          IstanbulCupriteRails::Istanbul::Collector.restore_original_files
        rescue StandardError => e
          warn "Istanbul cleanup failed: #{e.message}"
        end
      end
    end
  end
end
