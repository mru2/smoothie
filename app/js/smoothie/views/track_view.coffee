Smoothie.Views.TrackView = Backbone.View.extend {

  template: '
    <div class="overlay"></div>
    <a class="artist" href="<%= track.uploader_url %>"><%= track.uploader_name %></a>
    <br>
    <a class="title" href="<%= track.url %>"><%= track.title %></a>
  '

  initialize: () ->
    console.log 'Initializing TrackView'

  render: () ->
    if @model
      console.log 'Rendering TrackView'
      @$el.html( _.template @template, { track: @model } )
      @$el.css( 'background-image', "url(#{@model.artwork})" )

    return this
}