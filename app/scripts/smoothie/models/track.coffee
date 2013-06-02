# Track model
# Wraps a SoundCloud Track to make it a usable model

define ['backbone',
        'when',
        'smoothie/modules/soundcloud'], \

        (Backbone, When, Soundcloud) ->

  Track = Backbone.Model.extend { 

    defaults: {
      'title': '',
      'user_permalink': '',
      'username': '',
      'permalink_url': '',
      'artwork_url': ''
    }

    synced: false

    # Initialize from a soundcloud track id
    # sync() has to be called for it to be initialized
    initialize: (track_id) ->
      @id = track_id

    # Fetch the track attributes from soundcloud
    # Returns a promise
    sync: () ->
      deferred = When.defer()

      if @synced
        deferred.resolve(this)
      else
        Soundcloud.fetchTrack(@id)

        # On success
        .then (attributes) => 
          this.set attributes
          @synced = true
          deferred.resolve(this)

        # On fail
        .otherwise (error) -> 
          deferred.reject(error)

      deferred.promise


    # Add the track to the current user favorites
    like: () ->
      Soundcloud.likeTrack(@id).then () =>
        this.set 'liked', true
        this

    # Remove the track from the favorites
    unlike: () ->
      Soundcloud.unlikeTrack(@id).then () =>
        this.set 'liked', false
        this

  }