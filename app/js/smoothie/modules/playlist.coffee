define ['smoothie/views/player_view',
        'smoothie/modules/player'], \

        (PlayerView, Player) ->

  Playlist = ( () -> 
    {

      # The current track index
      index: null

      # The fetched tracks array
      tracks: []

      # The current seed
      seed: null

      # The buffer after which tracks are fetched again
      buffer: 8

      init: (user_id, callback) ->
        @user_id = user_id
        @index = 0
        this.fetchTracks (tracks) =>
          Player.init(@getCurrentTrack())
          typeof callback == 'function' && callback()

      # Change tracks
      next: () ->
        @index += 1
        PlayerView.moveTracksForward()
        Player.fetchTrack(@getCurrentTrack())
        this.fetchTracks() if @index > (@tracks.length - 1 - @buffer)

      previous: () ->
        @index -= 1
        PlayerView.moveTracksBackward()
        Player.fetchTrack(@getCurrentTrack())

      # Get tracks
      getPreviousTrack: () ->
        @tracks[@index - 1]

      getCurrentTrack: () ->
        @tracks[@index]

      getNextTrack: () ->
        @tracks[@index + 1]

      # Fetch tracks from api
      fetchTracks: (callback) ->
        return if @fetching == true
        @fetching = true

        url =  "/api/v1/tracks.json"
        url += "?id=#{@user_id}"
        url += "&seed=#{@seed}" if @seed
        url += "&offset=#{@tracks.length}"

        console.log "Fetching #{url}"
        $.getJSON url, (tracks) =>
          @seed = tracks.seed
          @tracks.push track for track in tracks.tracks
          @fetching = false

          typeof callback == 'function' && callback(tracks)
    }
  )()
