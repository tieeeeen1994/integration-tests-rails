# frozen_string_literal: true

module IntegrationTestsRails
  class Configuration
    attr_accessor :source_dir, :output_dir, :backup_dir, :coverage_path, :wait_time, :remote, :chrome_url,
                  :verbose, :timeout, :server_host, :server_port, :puma_threads, :window_size, :max_server_retries

    def initialize
      @backup_dir = 'tmp/js_backup'
      @chrome_url = nil
      @coverage_path = 'coverage/nyc'
      @max_server_retries = 1000
      @output_dir = 'tmp/instrumented_js'
      @puma_threads = '1:1'
      @remote = false
      @server_host = '0.0.0.0' # rubocop:disable Style/IpAddresses
      @server_port = nil
      @source_dir = 'app/javascript'
      @timeout = 30
      @verbose = false
      @wait_time = 5
      @window_size = [1920, 1080]
    end

    def source_path
      Rails.root.join(source_dir)
    end

    def output_path
      Rails.root.join(output_dir)
    end

    def backup_path
      Rails.root.join(backup_dir)
    end

    def coverage_dir
      Rails.root.join(coverage_path)
    end

    def coverage_file
      coverage_dir.join('coverage.json')
    end
  end
end
