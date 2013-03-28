require 'soundcloud'

module Smoothie
  class SoundcloudClient

    attr_reader :client

    def initialize(opts = {})
      if opts[:access_token]
        @client = Soundcloud.new( opts )
      else
        @client = Soundcloud.new( default_client_params.merge(opts) )
      end
    end

    # Get the data relevant to a track (exluding uploader details)
    def get_track(track_id)
      track_data = @client.get("/tracks/#{track_id}")

      return {
        :uploader_id  => track_data.user_id,
        :title        => track_data.title,
        :url          => track_data.permalink_url,
        :artwork      => track_data.artwork_url
      }
    end

    # Get a user relevant data
    def get_user(user_id)
      user_data = @client.get("/users/#{user_id}")

      return {
        :username => user_data.username,
        :url      => user_data.permalink_url 
      }
    end

    # Get a user favorites
    def get_user_favorites(user_id, limit)
      user_favorites_data = @client.get("/users/#{user_id}/favorites", :limit => limit)

      return user_favorites_data.map(&:id)
    end


    private

    def default_client_params
      params = YAML.load_file(File.join(ENV['APP_ROOT'], 'config', 'soundcloud.yml'))[ENV["RACK_ENV"]]

      # Symbolizing keys
      params.keys.each{|key|params[key.to_sym] = params.delete(key)}

      return params
    end

  end
end