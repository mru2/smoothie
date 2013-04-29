# Track view
# Handles the rendering of a single track

define ['backbone',
        'jquery',
        'underscore',
        'smoothie/models/track'], \

        (Backbone, $, _, Track) ->

  TrackView = Backbone.View.extend {

    template:
      '<div class="overlay"></div>' +
      '<a class="artist" href="<%= user_permalink %>"><%= username %></a>' +
      '<br/>' +
      '<a class="title" href="<%= permalink_url %>"><%= title %></a>'


    # Initialize with a track
    initialize: () ->
      @model = @options.model

    # Render the track
    render: () ->
      console.log('rendering track with model attributes', @model.attributes)

      @$el.html('')

      # Waiting background
      @$el.css( 'background-image', 'url(/images/spinner.gif)' )
          .css( 'background-color', 'black')
          .css( 'background-size' , 'inherit')

      # When the model is fetched, re-render
      @model.then (track) =>
        @model = track
        @$el.html( _.template @template, @model.attributes )

        # Set the background according to the artwork
        if @model.get('artwork_url')

          # Async background image loading
          $('<img/>').attr('src', @model.get('artwork_url')).load () =>
            @$el.css( 'background-image',  "url(#{@model.get('artwork_url')})" )
                .css( 'background-size',   'cover' )

        else
          @$el.css( 'background-image', 'url(/images/default-track-bg.png)')
              .css( 'background-color', '#F2F2F2')
              .css( 'background-size' , 'inherit')

      this

  }