# A wrapper around the soundcloud player
# Responsible for playing tracks audio

define  ['soundcloud'], \

        (Soundcloud) ->


  Player = ( () -> 

    {    

      # Events :
      # - player:finished : the track has finished playing

      # Change the current track being played
      setTrackId: (track_id) ->

      # Pause the player
      pause: () ->

      # Unpause the player
      play: () ->



      # player: null

      # init: (track_id) ->
      #   @fetch_player track_id, (player) =>
      #     @player = player
      #     @player.load()      

      # playing: () ->
      #   @player && !@player.paused

      # fetchTrack: (track_id) ->
      #   @fetch_player track_id, (player) =>
      #     @player.destruct() if @player
      #     @player = player
      #     @play()

      # play: () ->
      #   @player.play {
      #     onfinish: () ->
      #       Playlist.next()
      #     }
      #   PlayerView.render()    

      # pause: () ->
      #   @player.pause() if @player
      #   PlayerView.render()    

      # fetch_player: (track_id, callback) ->
      #   track_url = "/tracks/#{track_id}"
      #   SC.stream track_url, (player) ->
      #     callback(player)
    }

  )()