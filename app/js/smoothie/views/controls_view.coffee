define ['jquery',
        'backbone',
        'smoothie/modules/player',
        'smoothie/modules/playlist'], \

        ($, Backbone, Player, Playlist) ->

  ControlsView = Backbone.View.extend {

    template_id: '#controls-template'

    events: {
      "click #play":    "onPlay",
      "click #pause":   "onPause",
      "click #next":    "onNext",
      "click #prev":    "onPrevious"
    }

    onPlay: () ->
      Player.play()

    onPause: () ->
      Player.pause()

    onPrevious: () ->
      Playlist.previous() 

    onNext: () ->
      Playlist.next() 

    # Render
    render: () ->
      template = $(@template_id).html()
      @$el.html( _.template template, { playing: Player.playing() } )
  }
