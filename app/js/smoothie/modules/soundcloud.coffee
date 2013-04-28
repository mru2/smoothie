# A wrapper around the soundcloud api and the current user

define  ['soundcloud_sdk', 'when'], \

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
        artwork_url: track.artwork_url && track.artwork_url.replace(/-large.jpg?.*$/, '-t500x500.jpg')
      }


    {

      # Authenticate the SDK
      # Should be handled internally in a souncloud callback
      initialize: (opts) ->        
        SC.accessToken(opts.access_token) if opts.access_token


      # Fetch and format a track
      fetchTrack: (track_id) ->
        deferred = When.defer()

        SC.get "/tracks/#{track_id}", (track) ->
          deferred.resolve( formatTrack(track) )

        deferred.promise

    }

  )()
