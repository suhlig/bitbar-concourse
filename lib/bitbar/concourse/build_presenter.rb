# frozen_string_literal: true

require 'forwardable'
require 'relative_time'

module Bitbar
  module Concourse
    class BuildPresenter
      extend Forwardable
      def_delegator :@build, :end_time
      def_delegator :@build, :success?

      def initialize(build)
        raise 'Build must not be nil' if build.nil?

        @build = build
      end

      def to_s
        icon = @build.success? ? '✅' : '❌'

        lines = [
          "#{icon}  #{@build.job_name} - build ##{@build.name} | href=#{@build.url}",
          "finished #{relative_end_time}; took #{elapsed_time}"
        ]

        if next_build = @build.next
          started_at = next_build.start_time.extend(RelativeTime).to_relative
          lines << "next build (##{next_build.name}) started #{started_at} | href=#{next_build.url}"
        end

        lines.join("\n")
      end

      def elapsed_time
        case difference = @build.end_time.to_i - @build.start_time.to_i
        when 0..59
          "#{difference} seconds"
        when 60..80
          'one minute'
        when 81..(60 * 25)
          "#{difference / 60} minutes"
        when (60 * 26)..(60 * 35)
          'about half an hour'
        else
          "#{difference}s"
        end
      end

      def relative_end_time
        @build.end_time&.extend(RelativeTime)&.to_relative
      end
    end
  end
end
