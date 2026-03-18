# frozen_string_literal: true

module IntegrationTestsRails
  module Capybara
    # Handles auto-retry logic for RSpec feature examples.
    module Retry
      class << self
        def run(example, context)
          description = example.full_description
          attempts, sleep_duration, capture_exceptions = retry_config(example)

          (attempts + 1).times do |attempt_number|
            reset_example_state(context)
            example.run
            ex = example.exception
            break unless ex
            break unless capture_exceptions.any? { |klass| ex.is_a?(klass) }

            Util.log "Auto Retry Attempt #{attempt_number + 1} failed for: #{description} (#{ex.class})"
            sleep(sleep_duration) if attempt_number < attempts && sleep_duration.positive?
          end
        end

        private

        def retry_config(example)
          kwargs = example.metadata.fetch(:auto_retry, {})
          config_obj = IntegrationTestsRails.configuration
          attempts = kwargs.fetch(:attempts, config_obj.retry_attempts)
          sleep_duration = kwargs.fetch(:sleep_duration, config_obj.retry_sleep_duration)
          capture_exceptions = constantize_exceptions(config_obj)
          [attempts, sleep_duration, capture_exceptions]
        end

        def constantize_exceptions(config)
          config.retry_capture_exceptions.filter_map { |e| e.constantize if e.is_a?(String) }
        end

        def reset_example_state(context)
          RSpec.current_example.instance_variable_set(:@exception, nil)
          memoized_class = begin
            RSpec::Core::MemoizedHelpers::ThreadsafeMemoized
          rescue StandardError
            RSpec::Core::MemoizedHelpers::NonThreadSafeMemoized
          end
          context.instance_variable_set(:@__memoized, memoized_class.new)
        end
      end
    end
  end
end
