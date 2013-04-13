require 'user'

# A track model
module Smoothie
  class Track

    include Redis::Objects

    value :title
    value :artwork
    value :url
    value :uploader_id

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

    def uploader_name
      uploader && uploader.username
    end

    def uploader_url
      uploader && uploader.url
    end

    def uploader
      User.new(uploader_id.value)
    end

    def synced?
      synced_at && !synced_at.value.nil?
    end

    def uploader_synced?
      uploader && uploader.synced?
    end

    def set_synced!
      self.synced_at = Time.now
    end

    def serialize
      {
        :id => id,
        :title => title.value,
        :url => url.value,
        :artwork => artwork.value,
        :uploader_name => uploader_name,
        :uploader_url => uploader_url
      }
    end

  end
end