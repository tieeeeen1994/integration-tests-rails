# frozen_string_literal: true

require_relative 'capybara/util'
require_relative 'capybara/remote'
require_relative 'capybara/local'

module IstanbulCupriteRails
  module Capybara
    class << self
      def setup
        config = IstanbulCupriteRails.configuration

        require 'capybara/cuprite'

        ::Capybara.javascript_driver = :cuprite

        # Auto-detect remote mode if not specified
        remote = config.remote.nil? ? Util.remote? : config.remote
        chrome_url = config.chrome_url

        if remote
          Remote.setup(wait_time: config.wait_time, chrome_url: chrome_url)
        else
          Local.setup(wait_time: config.wait_time)
        end

        Util.configure_rspec
        Util.configure_webmock if config.webmock
      end
    end
  end
end
