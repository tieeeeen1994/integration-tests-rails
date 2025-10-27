# frozen_string_literal: true

require 'capybara/cuprite'
require_relative 'capybara/util'
require_relative 'capybara/remote'
require_relative 'capybara/local'

module IstanbulCupriteRails
  module Capybara
    class << self
      def setup
        config = IstanbulCupriteRails.configuration

        ::Capybara.javascript_driver = :cuprite

        if config.remote
          Remote.setup
        else
          Local.setup
        end

        Util.configure_rspec
        Util.configure_webmock
      end
    end
  end
end
