Smoothie.Views.ControlsView = Backbone.View.extend {

  template: '
    <a class="control pull-left" id="prev"><i class="icon-backward"></i></a>
    <% if (playing) { %>
      <a class="control" id="pause"><i class="icon-pause"></i></a>
    <% } else { %>
      <a class="control" id="play"><i class="icon-play"></i></a>
    <% } %>
    <a class="control pull-right" id="next"><i class="icon-forward"></i></a>
  '

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

  onPause: () ->
    Smoothie.Modules.Player.pause()

  onPrevious: () ->
    Smoothie.Modules.Playlist.previous() 

  onNext: () ->
    Smoothie.Modules.Playlist.next() 

  # Render
  render: () ->
    @$el.html( _.template @template, { playing: Smoothie.Modules.Player.playing } )

}
