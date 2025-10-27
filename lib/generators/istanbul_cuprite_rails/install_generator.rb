# frozen_string_literal: true

require 'rails/generators'

module IstanbulCupriteRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Install Istanbul + Cuprite + Rails Setup'

      def install_node_dependencies
        unless system('which yarn > /dev/null 2>&1')
          say 'Yarn is not installed. Please install Yarn first: https://yarnpkg.com/getting-started/install', :red
          exit 1
        end

        say 'Installing Istanbul...', :green
        run 'yarn add --dev istanbul-lib-instrument istanbul-lib-coverage istanbul-lib-report istanbul-reports'
        run 'yarn install'
      end

      def copy_tests_controller
        template 'tests_controller.rb', 'spec/support/features/tests_controller.rb'
      end

      def add_route
        route 'resources(:tests, only: :index) if Rails.env.test?'
      end
    end
  end
end
