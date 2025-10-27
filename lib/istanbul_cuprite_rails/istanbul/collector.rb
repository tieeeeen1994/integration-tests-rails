# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'pathname'
require 'shellwords'

module IstanbulCupriteRails
  module Istanbul
    module Collector
      class << self
        def setup
          config = IstanbulCupriteRails.configuration

          # Instrument files
          Instrumenter.instrument_all

          # Backup and replace original files
          backup_and_replace_files

          # Clean previous coverage data
          FileUtils.rm_rf(config.coverage_dir)
          FileUtils.mkdir_p(config.coverage_dir)
        end

        def collect(page)
          coverage_data = page.evaluate_script('window.__coverage__')
          save_coverage_snapshot(coverage_data) if coverage_data.present?
        rescue StandardError => e
          Util.log "Coverage collection failed: #{e.message}"
        end

        def generate_report
          # Generate report using Node.js (will merge all snapshot files)
          report_script = build_report_script
          output = `node -e #{Shellwords.escape(report_script)} 2>&1`.strip

          # Parse and display coverage summary
          return if output.blank?

          begin
            data = JSON.parse(output)
            puts "\nJavaScript Coverage: #{data['covered']} / #{data['total']} LOC (#{data['pct']}%) covered."
            puts "Coverage report: coverage/javascript/index.html\n"
          rescue JSON::ParserError
            puts output
          end
        end

        def restore_original_files
          config = IstanbulCupriteRails.configuration

          backup_dir = config.backup_path
          source_dir = config.source_path

          return unless Dir.exist?(backup_dir)

          FileUtils.rm_rf(source_dir)
          FileUtils.cp_r(backup_dir, source_dir)
          Util.log '✓ Restored original JavaScript files'
        end

        private

        def backup_and_replace_files
          config = IstanbulCupriteRails.configuration

          # Backup originals
          FileUtils.rm_rf(config.backup_path)
          FileUtils.cp_r(config.source_path, config.backup_path)

          # Replace with instrumented
          Dir.glob(config.output_path.join('**/*.js')).each do |instrumented_file|
            relative_path = Pathname.new(instrumented_file).relative_path_from(config.output_path)
            target_file = config.source_path.join(relative_path)
            FileUtils.cp(instrumented_file, target_file)
          end
        end

        def save_coverage_snapshot(coverage_data)
          config = IstanbulCupriteRails.configuration

          snapshot_file = config.coverage_dir.join("js-#{Time.now.to_f.to_s.tr('.', '-')}.json")
          File.write(snapshot_file, JSON.pretty_generate(coverage_data))
        end

        def build_report_script
          config = IstanbulCupriteRails.configuration

          <<~JS
            const libCoverage = require('istanbul-lib-coverage');
            const libReport = require('istanbul-lib-report');
            const reports = require('istanbul-reports');
            const fs = require('fs');
            const path = require('path');

            const coverageDir = '#{config.coverage_dir}';
            const files = fs.readdirSync(coverageDir).filter(f => f.startsWith('js-') && f.endsWith('.json'));

            const coverageMap = libCoverage.createCoverageMap();

            files.forEach(file => {
              const filePath = path.join(coverageDir, file);
              const coverage = JSON.parse(fs.readFileSync(filePath, 'utf8'));
              coverageMap.merge(coverage);
            });

            // Add all instrumented files (even those with 0% coverage)
            function findJsFiles(dir, fileList = []) {
              const items = fs.readdirSync(dir);
              items.forEach(item => {
                const fullPath = path.join(dir, item);
                const stat = fs.statSync(fullPath);
                if (stat.isDirectory()) {
                  findJsFiles(fullPath, fileList);
                } else if (item.endsWith('.js')) {
                  fileList.push(fullPath);
                }
              });
              return fileList;
            }

            const instrumentedDir = '#{config.output_path}';
            const instrumentedFiles = findJsFiles(instrumentedDir);

            instrumentedFiles.forEach(instrumentedFile => {
              const relativePath = path.relative(instrumentedDir, instrumentedFile);
              const originalFile = path.join('#{config.source_path}', relativePath);

              if (coverageMap.data[originalFile]) return;

              try {
                const code = fs.readFileSync(instrumentedFile, 'utf8');
                const match = code.match(/var coverageData = (\\{[\\s\\S]+?\\});/);

                if (match && match[1]) {
                  const coverageData = eval('(' + match[1] + ')');
                  coverageData.path = originalFile;
                  coverageMap.addFileCoverage(coverageData);
                }
              } catch(e) {
                // Skip files that can't be parsed
              }
            });

            const context = libReport.createContext({
              dir: 'coverage/javascript',
              coverageMap: coverageMap
            });

            ['html', 'lcov', 'cobertura'].forEach(reportType => {
              const report = reports.create(reportType, {});
              report.execute(context);
            });

            const summary = coverageMap.getCoverageSummary();
            console.log(JSON.stringify({
              covered: summary.lines.covered,
              total: summary.lines.total,
              pct: summary.lines.pct.toFixed(2)
            }));
          JS
        end
      end
    end
  end
end
