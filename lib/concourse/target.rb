# frozen_string_literal: true

require 'uri'
require 'json'
require 'open-uri'
require 'net/https'

module Concourse
  #
  # A target has many pipelines
  #
  class Target
    attr_reader :name

    def initialize(client, name = nil)
      @client = client
      @name = name
    end

    def pipelines
      JSON.parse(get).map do |json|
        Pipeline.new(self, json)
      end
    end

    def get(path = '')
      @client.get('pipelines' + path)
    end

    def to_s
      "#{self.class.name.split('::').last.downcase} #{name}"
    end
  end
end
