require 'webmock/rspec'
require 'rspec'
require 'pry'
require 'pry-byebug'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
WebMock.disable_net_connect!

require 'concourse'
require 'bitbar'
