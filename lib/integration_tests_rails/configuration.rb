# frozen_string_literal: true

module IntegrationTestsRails
  # Configuration class for this gem to modify adjustable settings for Capybara, Cuprite and Istanbul.
  class Configuration
    DEFAULT_HTML_CONTENT = <<~HTML.squish
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <meta name="turbo-visit-control" content="reload">
          <%= csrf_meta_tags %>
          <%= csp_meta_tag %>

          <!-- If there are stylesheets to include, include them here for testing. -->
          <!-- E.g. The line below loads a stylesheet file located in app/assets/stylesheets/app.css -->
          <%#= stylesheet_link_tag :app, "data-turbo-track": "reload" %>

          <%= javascript_importmap_tags %>

          <!-- If there are JavaScript libraries not globally available, include them here for testing.-->
          <!-- E.g. The block below shows how to import a JavaScript module and attach it to the window object. -->
          <!-- The file is located in app/javascripts/libs/my_library.js -->
          <!--
          <script type="module">
            import MyLibrary from 'libs/my_library';
            window.MyLibrary = MyLibrary;
          </script>
          -->
        </head>
        <body>
          <!-- Include JavaScript libraries here instead if they need to be loaded much later. -->
          <!-- E.g. The line below loads a JavaScript file located in app/assets/javascripts/plugins/vendor.min.js -->
          <%#= javascript_include_tag 'plugins/vendor.min' %>
        </body>
      </html>
    HTML

    attr_accessor :source_dir, :output_dir, :backup_dir, :coverage_path, :wait_time, :remote,
                  :chrome_url, :tests_page_html, :window_size, :max_server_retries,
                  :verbose, :timeout, :server_host, :server_port, :puma_threads

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
      @tests_page_html = DEFAULT_HTML_CONTENT
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
