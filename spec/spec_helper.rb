$LOAD_PATH.unshift(File.expand_path('../../lib/application', __FILE__))

require 'sinatra'
require "sinatra/base"
require 'rack/test'
require "rubygems"
require "test/unit"
require "rspec"
require "fakeweb"

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.include Rack::Test::Methods
end
