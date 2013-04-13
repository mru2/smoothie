Smoothie.Views.TrackView = Backbone.View.extend {

  template_id: '#track-template'

  initialize: () ->
    console.log 'Initializing TrackView'

  render: () ->
    if @model
      template = $(@template_id).html()
      @$el.html( _.template template, { track: @model } )
      if @model.artwork
        @$el.css( 'background-image', "url(#{@model.artwork})" )
      else
        @$el.css( 'background-image', 'url(/img/default-track-bg.png)')
            .css( 'background-color', '#F2F2F2')
            .css( 'background-size' , 'inherit')



    return this
}