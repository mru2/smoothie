require './config/environment'
require 'app'
require 'resque/server'

run Rack::URLMap.new \
  "/"       => Smoothie::Application.new,
  "/resque" => Resque::Server.new
