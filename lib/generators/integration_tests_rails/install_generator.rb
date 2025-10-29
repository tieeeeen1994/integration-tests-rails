# frozen_string_literal: true

require 'rails/generators'

module IntegrationTestsRails
  module Generators
    # Generator responsible for setting up the Rails project with necessary tools to make integration testing possible.
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Initialize project for integration testing.'

      def install_node_dependencies
        unless system('which yarn > /dev/null 2>&1')
          say 'Yarn is not installed. Please install Yarn first: https://yarnpkg.com/getting-started/install', :red
          exit 1
        end

        say 'Installing Istanbul...', :green
        run 'yarn add --dev istanbul-lib-instrument istanbul-lib-coverage istanbul-lib-report istanbul-reports'
        run 'yarn install'
      end

      def update_gitignore
        gitignore_path = '.gitignore'
        lines_to_add = ['node_modules/', 'coverage/']

        return unless File.exist?(gitignore_path)

        content = File.read(gitignore_path)
        lines_to_add.each do |line|
          if content.include?(line)
            say "'#{line}' already exists in .gitignore", :blue
          else
            append_to_file gitignore_path, "\n#{line}\n"
            say "Added '#{line}' to .gitignore", :green
          end
        end
      end
    end
  end
end
