# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'pathname'
require 'shellwords'

module IntegrationTestsRails
  module Istanbul
    # Instruments JavaScript files for code coverage using Istanbul.
    module Instrumenter
      class << self
        def instrument_all
          config = IntegrationTestsRails.configuration
          output_path = config.output_path

          # Clean output directory
          FileUtils.rm_rf(output_path)
          FileUtils.mkdir_p(output_path)

          # Find all JS files
          js_files = Dir.glob(config.source_path.join('**/*.js'))
          Util.log "Instrumenting #{js_files.length} JavaScript files..."

          js_files.each do |file|
            instrument_file(file)
          end

          Util.log '✓ Instrumented files created'
          Util.log '=== Istanbul Instrumentation Complete ==='
        end

        def instrument_file(file)
          config = IntegrationTestsRails.configuration
          relative_path = Pathname.new(file).relative_path_from(config.source_path)
          output_file = config.output_path.join(relative_path)

          FileUtils.mkdir_p(output_file.dirname)

          code = File.read(file)
          instrumented = instrument_code_with_istanbul(code, file)

          write_instrumented_file(output_file, instrumented, relative_path)
        end

        private

        def instrument_code_with_istanbul(code, file)
          require 'tempfile'
          Tempfile.create(['code', '.js']) do |temp_code|
            temp_code.write(code)
            temp_code.flush

            js_command = build_istanbul_command(temp_code.path, file)
            `node -e #{Shellwords.escape(js_command)}`.strip
          end
        end

        def build_istanbul_command(code_path, file)
          escaped_code_path = JSON.generate(code_path)
          escaped_file = JSON.generate(file.to_s)

          <<~JS
            const fs = require('fs');
            const { createInstrumenter } = require('istanbul-lib-instrument');
            const instrumenter = createInstrumenter({ esModules: true, compact: false });
            const code = fs.readFileSync(#{escaped_code_path}, 'utf8');
            const filename = #{escaped_file};
            console.log(instrumenter.instrumentSync(code, filename));
          JS
        end

        def write_instrumented_file(output_file, instrumented, relative_path)
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
