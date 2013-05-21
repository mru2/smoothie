# Handles the tracks collection and their fetching from the api

define ['backbone', 'when', 'smoothie/models/track'], \

       (Backbone, When, Track) ->

  Playlist = Backbone.Collection.extend {

    # The track model used
    model: Track

    # The minimum number of tracks to keep fetched around the current one
    buffer_length: 10

    # The number of tracks to fetch with each request
    per_page: 20

    # The api base url
    url: ENV.apiUrl + "/tracks.json"


    # Initialization of playlist attributes
    initialize: (models, options) -> 

      # The seed used for the current playlist randomizer
      # Fetched from the api
      @seed = options.seed || '' 

      # The current track position in the playlist
      @current_index = options.index || 0 

      # The playlist's owner
      @user_id = options.user_id


    # Gets the current track
    # Returns a promise which will be fulfilled with the synced track
    getCurrentTrack: () -> 
      this.fetch()
      .then () =>
        @models[@current_index].sync()

    # Moves the current position
    # Also preloads the new current track and the next
    # Returns a promise for when the playlist buffer is fetched
    move: (delta) ->
      @current_index += delta
      this.fetch().then () => 
        @models[@current_index].sync()
        @models[@current_index+1].sync()
        return

    # Privates


    # Fetch enough models to keep the buffer filled
    fetch: () ->
      deferred = When.defer()

      # Do not fetch if the buffer is already filled
      if this.isBuffered()
        deferred.resolve()
      else
        $.getJSON @url, this.urlParams(), (response) =>
          # Updates the seed
          @seed = response.seed

          # Updates the models
          this.add response.tracks.map (id) ->
            parseInt(id)

          deferred.resolve()

      deferred.promise


    # Check if the models are correctly buffered (already fetched around the current index)
    isBuffered: () ->
      this.size() > (@current_index + @buffer_length)


    # Build the url parameters, according to the seed, current user, and already buffered tracks
    urlParams: () ->
      params = {
        id: @user_id,
        offset: this.size(),
        limit: @per_page
      }
      params.seed = @seed if @seed
      params

  }
