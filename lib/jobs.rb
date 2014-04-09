require 'redis'
require 'logger'

module Smoothie::Jobs

  def self.log
    @logger ||= Logger.new('log/jobs.log')
  end

end