Smoothie.Modules.Player = ( () -> 

  {    
    player: null

    init: (track_id) ->
      @fetch_player track_id, (player) =>
        @player = player
        @player.load()      

    playing: () ->
      @player && !@player.paused

    fetchTrack: (track_id) ->
      @fetch_player track_id, (player) =>
        @player.destruct() if @player
        @player = player
        @play()

    play: () ->
      @player.play {
        onfinish: () ->
          Smoothie.Modules.Playlist.next()
        }
      Smoothie.Views.PlayerView.render()    

    pause: () ->
      @player.pause() if @player
      Smoothie.Views.PlayerView.render()    

    fetch_player: (track_id, callback) ->
      track_url = "/tracks/#{track_id}"
      SC.stream track_url, (player) ->
        callback(player)
  }

)()