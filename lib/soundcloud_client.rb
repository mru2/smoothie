require 'soundcloud'
require 'singleton'

module Smoothie  
  class SoundcloudClient

    # The constants for the max page size and max offset for api queries
    MAX_PAGE_SIZE = 200
    MAX_OFFSET = 8000
    WAIT_AFTER_REQUEST = 30 # 5000 requests a day max => one every 17.xx seconds

    attr_reader :client

    def initialize(opts = {})
      @client = Soundcloud.new( opts )
    end

    def authorize_url
      client.authorize_url(:scope => "non-expiring")
    end

    # Get the data relevant to a track (exluding uploader details)
    def get_track_likers(track_id)
      Kernel.sleep WAIT_AFTER_REQUEST
      @client.get("/tracks/#{track_id}/favoriters", :limit => MAX_PAGE_SIZE)
    end

    # Get a user relevant data, and its favorites
    def get_user_likes(user_id)
      Kernel.sleep WAIT_AFTER_REQUEST
      @client.get("/users/#{user_id}/favorites", :limit => MAX_PAGE_SIZE)
    end

    # # Get a user favorites
    # def get_user_favorites(user_id, limit)
    #   return fetch_pages_for(limit) do |limit, offset|
        
    #   end
    # end

    # # Get a track favoriters
    # def get_track_favoriters(track_id, limit)
    #   return fetch_pages_for(limit) do |limit, offset|
    #     @client.get("/tracks/#{track_id}/favoriters", :limit => limit, :offset => offset).map(&:id)
    #   end
    # end


    # private


    # # Generates the limit/offset pairs to get an arbitrary number of records
    # # Use as follow : 
    # #   fetch_pages_for(a_big_number_of_records) do |limit, offset|
    # #     # your code here, having access to the limit and offsets for each page,
    # #     # the result will be joined when returned    
    # def fetch_pages_for(number, &block)

    #   # Handling max number of records fetchable
    #   if number > MAX_OFFSET + MAX_PAGE_SIZE
    #     number = MAX_OFFSET + MAX_PAGE_SIZE
    #   end

    #   # First generate the offset/limit pairs for the full page requests needed
    #   pages = (number/MAX_PAGE_SIZE).times.with_index.map{ |index|

    #     # Index in this scope is the request number, starting at 0
    #     offset = index * MAX_PAGE_SIZE
    #     limit = MAX_PAGE_SIZE
    #     {:offset => offset, :limit => limit}
    #   }

    #   # Then, if the number of records to fetch if inferior to the max page size, or if 
    #   # the full page requests do not sum to make the total number, there is a last request to make
    #   limit = number % MAX_PAGE_SIZE
    #   if limit > 0
    #     last_page = {:offset => (pages.count * MAX_PAGE_SIZE), :limit => limit}
    #     pages << last_page
    #   end

    #   # Lastly, call the given block for each request and merge the results
    #   results = pages.map{|page|
    #     Kernel.sleep WAIT_AFTER_REQUEST
    #     yield(page[:limit], page[:offset])
    #   }.flatten
      
    #   return results
    # end


  end
end