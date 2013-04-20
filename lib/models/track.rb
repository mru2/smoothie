require 'user'

# A track model
module Smoothie
  class Track

    include Redis::Objects

    value :users_count
    value :synced_at

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

  end
end