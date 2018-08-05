# frozen_string_literal: true

module Concourse
  #
  # A pipeline belongs to a target
  # A pipeline has many jobs
  #
  class Pipeline
    attr_reader :name

    def initialize(target, info)
      @target = target
      @info = info
    end

    def name
      @info['name']
    end

    def to_s
      "#{self.class.name.split('::').last.downcase} #{name} of #{@target}"
    end

    def url
      @target.url + @info['url']
    end

    def jobs
      JSON.parse(get).map do |job|
        Job.new(self, job)
      end
    end

    def get(path = '')
      @target.get("/#{name}/jobs#{path}")
    end
  end
end
