# Controls view
# Handles the rendering of the controls, and 
# forwards their events to the mediator

define ['backbone', 'underscore', 'jquery'], \

        (Backbone, _, $) ->

  ControlsView = Backbone.View.extend {

    el: '#controls-container'

    template: 
      '<div id="controls">' +
        '<a class="control pull-left" id="prev"><i class="icon-step-backward"></i></a>' +
        '<% if (playing) { %>' +
          '<a class="control" id="pause"><i class="icon-pause"></i></a>' +
        '<% } else { %>' +
          '<a class="control" id="play"><i class="icon-play"></i></a>' +
        '<% } %>' +
        '<a class="control pull-right" id="next"><i class="icon-step-forward"></i></a>' +
      '</div>'

    initialize: () ->
      @pubsub = @options.pubsub
      @playing = false

    # Events
    # - controls:play
    # - controls:pause
    # - controls:next
    # - controls:previous


    # Updates the playing status (paused or playing)
    setPlaying: (playing) ->
      @playing = playing

    # Render the controls
    render: () ->
      @$el.html( _.template @template, { playing: @playing } )



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
  }
