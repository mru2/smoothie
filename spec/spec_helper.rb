ENV['RACK_ENV'] = "test"

require File.join(File.expand_path(File.dirname(__FILE__)), '..', '/config/boot.rb')
require 'vcr'

VCR.configure do |conf|
  conf.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  conf.hook_into :webmock
  conf.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |conf|

  conf.before :each do
    $redis.flushdb

    Kernel.stub!(:sleep)
  end

end