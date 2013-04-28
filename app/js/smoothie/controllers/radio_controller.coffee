# Radio controller
# Manages the radio views
# Receive their events, and updates them and the modules accordingly

define ['backbone',
        'when',
        'smoothie/views/controls_view',
        'smoothie/views/tracks_view',
        'smoothie/modules/playlist',
        'smoothie/modules/player'], \

        (Backbone, When, ControlsView, TracksView, Playlist, Player) ->

  RadioController = ( () ->

    PubSub = _.extend {}, Backbone.Events

    controller = {

      # Bootstrap the app
      initialize: (options) ->
        console.log "Bootstraping the radio app"

        # Initializing the playlist
        @playlist = new Playlist [], {
          user_id: options.user_id
        }

        # Initializing the player
        @player = new Player {
          pubsub: PubSub
          track_id: @playlist.getTrack(0).id
        }

        # Initializing the views
        @controls_view = new ControlsView {
          pubsub: PubSub
        }

        tracks = [@playlist.getTrack(0), @playlist.getTrack(1)]
        When.all(tracks).then (tracks) =>
          console.log 'tracks ready, rendering'

          @tracks_view = new TracksView {
            pubsub: PubSub
            currentTrack: tracks[0]
            nextTrack: tracks[1]
          }

          console.log 'got tracks view', @tracks_view

          # Render the views
          @tracks_view.render()
          @controls_view.render()

        # Returning self for method chaining
        this


      # Event handlers

      onPlayerStopped: () ->
        @controls_view.setPlaying(false)

      onPlayerPlaying: () ->
        @controls_view.setPlaying(true)


      # Controls play/pause : update the player track and/or playing status
      play: () ->
        this.updateTrack()
        .then () =>
          @player.play()
        .then () =>
          @controls_view.setPlaying(true)

      pause: () ->
        @player.pause()
        @controls_view.setPlaying(false)

  
      # Previous : move the playlist cursor and fetches the new previous track to be rendered
      playPrevious: () ->
        return if @playlist.current_index == 0
        @playlist.move(-1)
        @playlist.getTrack(-1)
        .then (firstTrack) =>
          @tracks_view.moveBackward(firstTrack)
          this.updateTrack()

      # Next : move the playlist cursor and fetches the new next track to be rendered
      playNext: () ->
        @playlist.move(1)
        @playlist.getTrack(1).then (lastTrack) =>
          @tracks_view.moveForward(lastTrack)
          this.updateTrack()

      # Update the current player track, let the player handle playing status
      updateTrack: () ->
        @playlist.getTrack(0).then (track) =>
          @player.setTrackId(track.id)
    }

    # Events
    PubSub.on 'tracks:clicked_next controls:next',          controller.playNext,        controller
    PubSub.on 'tracks:clicked_previous controls:previous',  controller.playPrevious,    controller
    PubSub.on 'controls:play',                              controller.play,            controller
    PubSub.on 'controls:pause',                             controller.pause,           controller
    PubSub.on 'player:stopped',                             controller.onPlayerStopped, controller
    PubSub.on 'player:playing',                             controller.onPlayerPlaying, controller

    # Returns the controller
    controller

  )()

  window.radio = RadioController
