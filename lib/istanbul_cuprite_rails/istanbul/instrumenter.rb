# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'pathname'
require 'shellwords'

module IstanbulCupriteRails
  module Istanbul
    module Instrumenter
      class << self
        def instrument_all
          config = IstanbulCupriteRails.configuration
          root = Rails.root

          # Clean output directory
          FileUtils.rm_rf(config.output_path(root))
          FileUtils.mkdir_p(config.output_path(root))

          # Find all JS files
          js_files = Dir.glob(config.source_path(root).join('**/*.js'))
          Capybara::Util.log "Instrumenting #{js_files.length} JavaScript files..."

          js_files.each do |file|
            instrument_file(file)
          end

          Capybara::Util.log '✓ Instrumented files created'
          Capybara::Util.log '=== Istanbul Instrumentation Complete ==='
        end

        def instrument_file(file)
          config = IstanbulCupriteRails.configuration
          root = Rails.root

          relative_path = Pathname.new(file).relative_path_from(config.source_path(root))
          output_file = config.output_path(root).join(relative_path)

          FileUtils.mkdir_p(output_file.dirname)

          # Use Node.js to instrument the file
          code = File.read(file)
          escaped_code = JSON.generate(code)
          escaped_file = JSON.generate(file.to_s)

          js_command = <<~JS
            const { createInstrumenter } = require('istanbul-lib-instrument');
            const instrumenter = createInstrumenter({ esModules: true, compact: false });
            const code = #{escaped_code};
            const filename = #{escaped_file};
            console.log(instrumenter.instrumentSync(code, filename));
          JS

          instrumented = `node -e #{Shellwords.escape(js_command)}`.strip

          if $CHILD_STATUS.success?
            File.write(output_file, instrumented)
          else
            warn "Failed to instrument #{relative_path}"
          end
        end
      end
    end
  end
end
