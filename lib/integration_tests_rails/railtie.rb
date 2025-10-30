# frozen_string_literal: true

module IntegrationTestsRails
  # Railtie to integrate with Rails applications.
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), 'tasks', '*.rake')].each { |file| load file }
    end
  end
end
