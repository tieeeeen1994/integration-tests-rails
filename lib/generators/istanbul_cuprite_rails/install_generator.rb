# frozen_string_literal: true

require 'rails/generators'

module IstanbulCupriteRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Install Istanbul + Cuprite + Rails Setup'

      def copy_tests_controller
        template 'tests_controller.rb', 'spec/support/features/tests_controller.rb'
      end

      def add_route
        route 'resources(:tests, only: :index) if Rails.env.test?'
      end
    end
  end
end
