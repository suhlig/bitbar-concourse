# frozen_string_literal: true

module Bitbar
  module Concourse
    class ErrorPresenter
      def initialize(error, target_name)
        @error = error
        @target_name = target_name
      end

      def to_s
        "#{@target_name}\n---\n#{@error.message}"
      end
    end
  end
end
