# frozen_string_literal: true

module IstanbulCupriteRails
  class Configuration
    attr_accessor :source_dir, :output_dir, :backup_dir, :coverage_path
    attr_accessor :wait_time, :remote, :chrome_url, :webmock

    def initialize
      @source_dir = 'app/javascript'
      @output_dir = 'tmp/instrumented_js'
      @backup_dir = 'tmp/js_backup'
      @coverage_path = 'coverage/nyc'
      
      # Capybara configuration
      @wait_time = 5
      @remote = nil  # nil = auto-detect from ENV
      @chrome_url = nil  # nil = use ENV['CHROME_URL']
      @webmock = true
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
