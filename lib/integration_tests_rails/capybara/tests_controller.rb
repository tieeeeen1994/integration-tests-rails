# frozen_string_literal: true

# This provides a minimal page that loads your JavaScript
class TestsController < ActionController::Base
  def index
    render inline: IntegrationTestsRails.configuration.tests_page_html
  end
end
