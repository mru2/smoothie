require './config/environment'

# Rakefile
APP_FILE  = 'app.rb'
APP_CLASS = 'Smoothie::Application'

require 'resque/tasks'
require 'resque/pool/tasks'

task 'resque:setup' do
  Dir[File.dirname(__FILE__) + '/lib/jobs/**/*.rb'].each {|file| require file }
end

task "resque:pool:setup" do
  # # close any sockets or files in pool manager
  # ActiveRecord::Base.connection.disconnect!
  # # and re-open them in the resque worker parent
  # Resque::Pool.after_prefork do |job|
  #   ActiveRecord::Base.establish_connection
  # end
end