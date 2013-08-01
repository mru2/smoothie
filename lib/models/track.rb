require 'user'

# A track model
module Smoothie
  class Track

    EXPIRATION = 604800 # 1 week
    FAVORITES_EXPIRATION = 604800 # 1 week

    include Redis::Objects

    value :users_count
    value :synced_at
    value :favoriters_synced_at

    set   :user_ids

    # We want to guarantee that the uid is present
    def self.new(*args)
      (args == [nil]) ? nil : super
    end

    def initialize(uid)
      return nil unless uid

      @uid = uid
    end

    def id
      @uid
    end


    def synced?
      synced_at && !synced_at.value.nil?
    end

    def up_to_date?
      synced? && (Time.parse(synced_at.value) > (Time.now - EXPIRATION))
    end

    def set_synced!
      self.synced_at = Time.now
    end



    def favoriters_synced?
      favoriters_synced_at && !favoriters_synced_at.value.nil?
    end

    def favoriters_up_to_date?
      favoriters_synced? && (Time.parse(favoriters_synced_at.value) > (Time.now - FAVORITES_EXPIRATION))
    end

    def set_favoriters_synced!
      self.favoriters_synced_at = Time.now
    end

  end
end