# frozen_string_literal: true

module Concourse
  #
  # A job belongs to a pipeline
  # A job has many builds
  # A job has one finished_build
  # A job has one next_build
  #
  class Job
    attr_reader :pipeline

    def initialize(pipeline, info)
      @pipeline = pipeline
      @info = info
    end

    def name
      @info['name']
    end

    def to_s
      "#{self.class.name.split('::').last.downcase} #{name} of #{pipeline}"
    end

    def builds
      JSON.parse(@pipeline.get("/#{name}/builds")).map do |build|
        Build.new(self, build)
      end
    end

    def finished_build
      Build.new(self, @info['finished_build']) if @info['finished_build']
    end

    def next_build
      next_build = @info['next_build']
      Build.new(self, next_build) if next_build
    end

    def url
      @pipeline.url + @info['url']
    end
  end
end
