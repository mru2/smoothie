# Controls view
# Handles the rendering of the controls, and 
# forwards their events to the mediator

define ['backbone',
        'mediator'], \

        (Backbone, Mediator) ->

  ControlsView = Backbone.View.extend {

    template_id: '#controls-template'


    # Events
    # - controls:play
    # - controls:pause
    # - controls:next
    # - controls:previous


    # Updates the playing status (paused or playing)
    setPlaying: (playing) ->


    # Render the controls
    render: () ->



    # events: {
    #   "click #play":    "onPlay",
    #   "click #pause":   "onPause",
    #   "click #next":    "onNext",
    #   "click #prev":    "onPrevious"
    # }

    # onPlay: () ->
    #   Player.play()

    # onPause: () ->
    #   Player.pause()

    # onPrevious: () ->
    #   Playlist.previous() 

    # onNext: () ->
    #   Playlist.next() 

    # # Render
    # render: () ->
    #   template = $(@template_id).html()
    #   @$el.html( _.template template, { playing: Player.playing() } )
  }
