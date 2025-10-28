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

      let(:script) { nil }

      before do
        visit tests_path
        result
      end
    end
  end
end
