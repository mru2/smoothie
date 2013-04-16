ENV['RACK_ENV'] = "test"

require File.join(File.expand_path(File.dirname(__FILE__)), '..', '/config/boot.rb')

RSpec.configure do |conf|

  conf.before :each do
    $redis.flushdb
    ResqueSpec.reset!
  end

end