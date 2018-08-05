require 'uri'
require 'cgi'
require 'open-uri'
require 'net/https'

module Concourse
  class Client
    API_BASE_PATH = '/api/v1/teams/main/'.freeze

    attr_reader :base_uri

    def initialize(concourse_uri, username: nil, password: nil, options: {})
      @concourse_uri = URI(concourse_uri)
      @username = username
      @password = password
      @options = options
      @base_uri = @concourse_uri.merge(API_BASE_PATH)
    end

    def get(path)
      path = path[1..-1] if path.start_with?('/')

      begin
        options_with_auth = if authenticated?
                              options.merge('Cookie' => "ATC-Authorization=\"#{bearer_token}\"")
                            else
                              options
                            end

        open(base_uri.merge(path), options_with_auth).read
      rescue OpenURI::HTTPError => e
        if e.message == '401 Unauthorized' && @bearer_token
          @bearer_token = nil
          retry
        else
          raise
        end
      end
    end

    private

    attr_reader :options, :username, :password

    def bearer_token
      @bearer_token ||= authenticate
    end

    def authenticated?
      username && password
    end

    def authenticate
      io = open(
        @concourse_uri.merge('/auth/basic/token?team_name=main'),
        options.merge(http_basic_authentication: [@username, @password])
      )

      code, message = io.status
      raise message unless code == '200'

      json = JSON.parse(io.read)
      "#{json['type']} #{json['value']}"
    end
  end
end
