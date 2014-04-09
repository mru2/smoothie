require './config/environment'
require 'worker'

# Rakefile
APP_FILE  = 'app.rb'
APP_CLASS = 'Smoothie::Application'

task 'work' do
  Smoothie::Jobs::Worker.work
end
