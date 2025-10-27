# frozen_string_literal: true

# Controller for Istanbul Cuprite Rails JavaScript testing
# This provides a minimal page that loads your JavaScript
class TestsController < ActionController::Base # rubocop:disable Rails/ApplicationController
  def index
    render inline: <<~HTML # rubocop:disable Rails/RenderInline
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <meta name="turbo-visit-control" content="reload">
          <%%= csrf_meta_tags %>
          <%%= csp_meta_tag %>
          <%%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>
          <%%= stylesheet_link_tag 'custom', "data-turbo-track": "reload" %>
          <%%= javascript_importmap_tags %>
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
          <%%#= javascript_include_tag 'plugins/vendor.min' %>
        </body>
      </html>
    HTML
  end
end
