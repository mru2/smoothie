require 'base_job'
require 'user'

module Smoothie
  class Recommender < Smoothie::BaseJob

    include Resque::Plugins::UniqueJob

    @queue = :default

    EXPIRATION = 86400 # 1 day


    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']
      
      @user = Smoothie::User.new(@arguments['id'])
    end


    def ready?
      @user.recommendations_computed?(EXPIRATION)
    end


    def perform

      # Compute the recommendations
      @user.compute_recommendations!

    end
  end
end
