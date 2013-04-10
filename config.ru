require './config/boot'
require 'app'
require 'resque/server'

run Rack::URLMap.new \
  "/"       => Smoothie::Application.new,
  "/resque" => Resque::Server.new
