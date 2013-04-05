Smoothie.Views.ControlsView = Backbone.View.extend {

  template_id: '#controls-template'

  events: {
    "click #play":    "onPlay",
    "click #pause":   "onPause",
    "click #next":    "onNext",
    "click #prev":    "onPrevious"
  }

  onPlay: () ->
    Smoothie.Modules.Player.play()

  onPause: () ->
    Smoothie.Modules.Player.pause()

  onPrevious: () ->
    Smoothie.Modules.Playlist.previous() 

  onNext: () ->
    Smoothie.Modules.Playlist.next() 

  # Render
  render: () ->
    template = $(@template_id).html()
    @$el.html( _.template template, { playing: Smoothie.Modules.Player.playing() } )

}
