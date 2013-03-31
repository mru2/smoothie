Smoothie.Views.ControlsView = Backbone.View.extend {

  playing: false

  template: '
    <a class="control pull-left" id="prev"><i class="icon-backward"></i></a>
    <% if (playing) { %>
      <a class="control" id="pause"><i class="icon-pause"></i></a>
    <% } else { %>
      <a class="control" id="play"><i class="icon-play"></i></a>
    <% } %>
    <a class="control pull-right" id="next"><i class="icon-forward"></i></a>
  '

  initialize: () ->
    console.log 'Initializing ControlsView'

  render: () ->
    console.log 'Rendering ControlsView'
    @$el.html( _.template @template, { playing: @playing } )

}