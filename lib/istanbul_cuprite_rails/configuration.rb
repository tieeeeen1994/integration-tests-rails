# frozen_string_literal: true

module IstanbulCupriteRails
  class Configuration
    attr_reader :source_dir, :output_dir, :backup_dir, :coverage_path, :wait_time, :remote, :chrome_url, :webmock,
                :verbose

    def initialize
      @source_dir = 'app/javascript'
      @output_dir = 'tmp/instrumented_js'
      @backup_dir = 'tmp/js_backup'
      @coverage_path = 'coverage/nyc'
      @wait_time = 5
      @remote = false
      @chrome_url = nil
      @webmock = true
      @verbose = false
    end

    def source_path(root = Rails.root)
      root.join(source_dir)
    end

    def output_path(root = Rails.root)
      root.join(output_dir)
    end

    def backup_path(root = Rails.root)
      root.join(backup_dir)
    end

    def coverage_dir(root = Rails.root)
      root.join(coverage_path)
    end

    def coverage_file(root = Rails.root)
      coverage_dir(root).join('coverage.json')
    end
  end
end
