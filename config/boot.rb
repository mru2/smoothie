ENV["RACK_ENV"] ||= "development"

require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

ENV['APP_ROOT'] ||= File.expand_path('../..', __FILE__)
$LOAD_PATH.unshift ENV['APP_ROOT']
$LOAD_PATH.unshift File.join(ENV['APP_ROOT'], 'lib')
$LOAD_PATH.unshift File.join(ENV['APP_ROOT'], 'lib', 'models')
$LOAD_PATH.unshift File.join(ENV['APP_ROOT'], 'lib', 'jobs')

Dir[ENV['APP_ROOT'] + '/config/initializers/*.rb'].each do |file|
  require file
end

Encoding.default_external = 'utf-8'

require 'debugger' if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'test'
