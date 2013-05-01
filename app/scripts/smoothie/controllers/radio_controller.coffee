# Radio controller
# Manages the radio views
# Receive their events, and updates them and the modules accordingly

define ['backbone',
        'when',
        'smoothie/views/player_view',
        'smoothie/modules/playlist',
        'smoothie/modules/player'], \

        (Backbone, When, PlayerView, Playlist, Player) ->

  RadioController = ( () ->

    PubSub = _.extend {}, Backbone.Events

    controller = {

      # Bootstrap the app
      initialize: (options) ->
        # Initializing the playlist
        @playlist = new Playlist [], {
          user_id: options.userId
        }

        @playlist.getCurrentTrack().then (track) =>

          # Initializing the player
          @player = new Player {
            pubsub: PubSub
            track_id: track.id
          }

          # Initializing the player view
          @player_view = new PlayerView {
            el: '#player-container'
            model: track
            pubsub: PubSub
            playing: false
          }

          @player_view.render()


      # Play/pause : update the player track and/or playing status
      play: () -> @player.play()
      pause: () -> @player.pause()

      onPlaying: () -> @player_view.setPlaying(true)
      onPaused: () -> @player_view.setPlaying(false)

        
      # Previous : plays the previous track
      playPrevious: () ->
        return if @playlist.current_index == 0
        @playlist.move(-1)
        .then () =>
          @playlist.getCurrentTrack()
        .then (track) =>
          @player.setTrackId(track.id)
          @player_view.setTrack(track)

      # Next : plays the next track
      playNext: () ->
        @playlist.move(1)
        .then () =>
          @playlist.getCurrentTrack()
        .then (track) =>
          @player.setTrackId(track.id)
          @player_view.setTrack(track)

    }

    # Events
    PubSub.on 'player:next player:finished',  controller.playNext,        controller
    PubSub.on 'player:previous',              controller.playPrevious,    controller
    PubSub.on 'player:play',                  controller.play,            controller
    PubSub.on 'player:pause',                 controller.pause,           controller
    PubSub.on 'player:playing',               controller.onPlaying,       controller
    PubSub.on 'player:paused',                controller.onPaused,        controller

    # Returns the controller
    controller

  )()

  window.radio = RadioController
