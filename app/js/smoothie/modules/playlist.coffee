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
    url: "/api/v1/tracks.json"


    # Initialization of playlist attributes
    initialize: (models, options) -> 

      # The seed used for the current playlist randomizer
      # Fetched from the api
      @seed = options.seed || '' 

      # The current track position in the playlist
      @current_index = options.index || 0 

      # The playlist's owner
      @user_id = options.user_id


    # Gets the track relative to the current position
    # Returns a promise which will be fulfilled with the synced track
    getTrack: (delta) -> 
      this.fetch()
      .then () =>
        position = @current_index + delta
        return null if position < 0
        @models[position].sync()

    # Moves the current position
    move: (delta) ->
      @current_index += delta



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




    # # The current track index
    # index: null

    # # The fetched tracks array
    # tracks: []

    # # The current seed
    # seed: null

    # # The buffer after which tracks are fetched again
    # buffer: 8

    # init: (user_id, callback) ->
    #   @user_id = user_id
    #   @index = 0
    #   this.fetchTracks (tracks) =>
    #     Player.init(@getCurrentTrack())
    #     typeof callback == 'function' && callback()

    # # Change tracks
    # next: () ->
    #   @index += 1
    #   PlayerView.moveTracksForward()
    #   Player.fetchTrack(@getCurrentTrack())
    #   this.fetchTracks() if @index > (@tracks.length - 1 - @buffer)

    # previous: () ->
    #   @index -= 1
    #   PlayerView.moveTracksBackward()
    #   Player.fetchTrack(@getCurrentTrack())

    # # Get tracks
    # getPreviousTrack: () ->
    #   @tracks[@index - 1]

    # getCurrentTrack: () ->
    #   @tracks[@index]

    # getNextTrack: () ->
    #   @tracks[@index + 1]

    # # Fetch tracks from api
    # fetchTracks: (callback) ->
    #   return if @fetching == true
    #   @fetching = true

    #   url =  "/api/v1/tracks.json"
    #   url += "?id=#{@user_id}"
    #   url += "&seed=#{@seed}" if @seed
    #   url += "&offset=#{@tracks.length}"

    #   console.log "Fetching #{url}"
    #   $.getJSON url, (tracks) =>
    #     @seed = tracks.seed
    #     @tracks.push track for track in tracks.tracks
    #     @fetching = false

    #     typeof callback == 'function' && callback(tracks)
  }
