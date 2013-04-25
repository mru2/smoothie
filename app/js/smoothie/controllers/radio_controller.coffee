# Radio controller
# Manages the radio views
# Receive their events, and updates them and the modules accordingly

define ['backbone',
        'underscore',
        'smoothie/views/controls_view',
        'smoothie/views/tracks_view',
        'smoothie/modules/playlist',
        'smoothie/modules/player'], \

        (Backbone, ControlsView, TracksView, Playlist, Player) ->

  RadioController = ( () ->

    pubsub = _.extend {}, Backbone.Events

    {
      bootstrap: () ->
        console.log "Bootstraping the radio app"
        console.log "The events are", pubsub
    }

  )()
