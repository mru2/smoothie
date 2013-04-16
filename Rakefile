require './config/boot'

# Rakefile
APP_FILE  = 'app.rb'
APP_CLASS = 'Smoothie::Application'

require 'sinatra/assetpack/rake'
require 'resque/tasks'

task 'resque:setup' do
  Dir[File.dirname(__FILE__) + '/lib/jobs/*.rb'].each {|file| require file }
  # Dir[File.dirname(__FILE__) + '/lib/jobs/*.rb'].each {|file| require file }
  # module Smoothie ; end
end