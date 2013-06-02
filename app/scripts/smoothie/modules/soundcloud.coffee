# A wrapper around the soundcloud api and the current user

define  ['soundcloudSdk', 'when'], \

        (SC, When) ->

  Soundcloud = ( () -> 

    # The track attributes used for the track models
    formatTrack = (track) ->
      {
        # The track attributes
        title: track.title,
        user_permalink: track.user.permalink_url,
        username: track.user.username,
        permalink_url: track.permalink_url,
        artwork_url: track.artwork_url && track.artwork_url.replace(/-large.jpg?.*$/, '-t500x500.jpg'),
        liked: track.user_favorite
      }


    {

      # Authenticate the SDK
      initialize: (opts) ->
        SC.initialize
          client_id: ENV.SC.clientId
          redirect_uri: ENV.SC.redirectUri

      # Fetch and format a track
      fetchTrack: (track_id) ->
        deferred = When.defer()

        SC.get "/tracks/#{track_id}", (track) ->
          deferred.resolve( formatTrack(track) )

        deferred.promise

      # Gets the audio stream associated to a track
      getTrackStream: (track_id, options) ->
        SC.stream "/tracks/#{track_id}", options

      # Add a track to favorites
      likeTrack: (track_id) ->
        deferred = When.defer()
        SC.put "/me/favorites/#{track_id}", () -> 
          deferred.resolve()
        deferred.promise

      # Remove a track from favorites
      unlikeTrack: (track_id) ->
        deferred = When.defer()
        SC.delete "/me/favorites/#{track_id}", () -> 
          deferred.resolve()
        deferred.promise

    }

  )()
