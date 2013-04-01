Smoothie.Views.TrackView = Backbone.View.extend {

  template_id: '#track-template'

  initialize: () ->
    console.log 'Initializing TrackView'

  render: () ->
    if @model
      template = $(@template_id).html()
      @$el.html( _.template template, { track: @model } )
      @$el.css( 'background-image', "url(#{@model.artwork})" )

    return this
}