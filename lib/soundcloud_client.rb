require 'soundcloud'

module Smoothie
  class SoundcloudClient

    # The constants for the max page size and max offset for api queries
    MAX_PAGE_SIZE = 200
    MAX_OFFSET = 8000
    WAIT_AFTER_REQUEST = 20 # 5000 requests a day max => one every 17.xx seconds

    attr_reader :client

    def initialize(opts = {})
      if opts[:access_token]
        @client = Soundcloud.new( opts )
      else
        @client = Soundcloud.new( default_client_params.merge(opts) )
      end
    end

    def authorize_url
      client.authorize_url(:scope => "non-expiring")
    end

    # Get the data relevant to a track (exluding uploader details)
    def get_track(track_id)
      track_data = @client.get("/tracks/#{track_id}")

      return {
        # :uploader_id  => track_data.user_id,
        # :title        => track_data.title,
        # :url          => track_data.permalink_url,
        # :artwork      => (track_data.artwork_url ? track_data.artwork_url.gsub(/-large.jpg?.*$/, '-t500x500.jpg') : nil),
        :users_count  => track_data.favoritings_count
      }
    end

    # Get a user relevant data
    def get_user(user_id)
      user_data = @client.get("/users/#{user_id}")

      return {
        # :username      => user_data.username,
        # :url           => user_data.permalink_url,
        :tracks_count  => user_data.public_favorites_count
      }
    end

    # Get a user favorites
    def get_user_favorites(user_id, limit)
      return fetch_pages_for(limit) do |limit, offset|
        @client.get("/users/#{user_id}/favorites", :limit => limit, :offset => offset).map(&:id)
      end
    end


    private

    def default_client_params
      params = YAML.load_file(File.join(ENV['APP_ROOT'], 'config', 'soundcloud.yml'))[ENV["RACK_ENV"]]

      # Symbolizing keys
      params.keys.each{|key|params[key.to_sym] = params.delete(key)}

      return params
    end


    # Generates the limit/offset pairs to get an arbitrary number of records
    # Use as follow : 
    #   fetch_pages_for(a_big_number_of_records) do |limit, offset|
    #     # your code here, having access to the limit and offsets for each page,
    #     # the result will be joined when returned    
    def fetch_pages_for(number, &block)
      if number > MAX_OFFSET + MAX_PAGE_SIZE
        raise "Cannot fetch more than #{MAX_OFFSET + MAX_PAGE_SIZE} records from the soundcloud API"
      end

      # First generate the offset/limit pairs for the full page requests needed
      pages = (number/MAX_PAGE_SIZE).times.with_index.map{ |index|

        # Index in this scope is the request number, starting at 0
        offset = index * MAX_PAGE_SIZE
        limit = MAX_PAGE_SIZE
        {:offset => offset, :limit => limit}
      }

      # Then, if the number of records to fetch if inferior to the max page size, or if 
      # the full page requests do not sum to make the total number, there is a last request to make
      limit = number % MAX_PAGE_SIZE
      if limit > 0
        last_page = {:offset => (pages.count * MAX_PAGE_SIZE), :limit => limit}
        pages << last_page
      end

      # Lastly, call the given block for each request and merge the results
      results = pages.map{|page| yield(page[:limit], page[:offset])}.flatten
      return results
    end


  end
end