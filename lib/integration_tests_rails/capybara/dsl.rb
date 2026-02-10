# frozen_string_literal: true

module IntegrationTestsRails
  module Capybara
    # This module provides the main DSL for writing integration tests with Capybara.
    module Dsl
      def retry_on_fail(attempts: nil, sleep_duration: nil)
        config = IntegrationTestsRails.configuration
        attempts ||= config.retry_attempts
        sleep_duration ||= config.retry_sleep_duration
        counter = 0

        begin
          yield
        rescue RSpec::Expectations::ExpectationNotMetError, Capybara::ElementNotFound => e
          counter += 1
          Util.log("Attempt #{counter} for #{RSpec.current_example.full_description} failed!")
          raise e if counter > attempts

          sleep(sleep_duration) if sleep_duration.positive?
          retry
        end
      end
    end
  end
end
