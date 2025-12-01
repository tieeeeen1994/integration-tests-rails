# frozen_string_literal: true

module IntegrationTestsRails
  module Capybara
    # Adds helpers to enable unit testing.
    module Helper
      extend RSpec::SharedContext

      let(:result) do
        case script
        when Array
          script.map { |cmd| page.evaluate_script(cmd) }.last
        when String
          page.evaluate_script(script)
        end
      end

      let(:script) do
        case function
        when Array
          function.map! do |fn|
            <<~JSCODE
              (() => {
                #{fn}
              })();
            JSCODE
          end
        when String
          <<~JSCODE
            (() => {
              #{function}
            })();
          JSCODE
        end
      end

      let(:function) { nil }

      before do
        # page.driver.wait_for_network_idle(timeout: IntegrationTestsRails.configuration.timeout)
        visit '/tests'
        result
      end
    end
  end
end
