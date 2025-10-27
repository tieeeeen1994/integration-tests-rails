# frozen_string_literal: true

module IstanbulCupriteRails
  module Istanbul
    module Util
      class << self
        def log(message)
          return unless verbose?

          puts "[ISTANBUL] #{message}"
        end

        private

        def verbose?
          IstanbulCupriteRails.configuration&.verbose
        end
      end
    end
  end
end
