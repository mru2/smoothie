# Track view
# Handles the rendering of a single track

define ['backbone',
        'smoothie/models/track'], \

        (Backbone, Track) ->

  TrackView = Backbone.View.extend {

    template_id: '#track-template'


    # Events
    # track:clicked : the track has been clicked


    # Initialize with a track
    initialize: (track) ->


    # Render the track
    render: () ->



    # initialize: () ->
    #   @track_id = @options.track_id

    # render: () ->
    #   if @track_id
    
    #     SC.get "/tracks/#{@track_id}", (track) =>
    
    #       template = $(@template_id).html()

    #       @$el.html( _.template template, { track: track } )

    #       if track.artwork_url
    #         @$el.css( 'background-image', "url(#{track.artwork_url.replace(/-large.jpg?.*$/, '-t500x500.jpg')})" )
    #       else
    #         @$el.css( 'background-image', 'url(/img/default-track-bg.png)')
    #             .css( 'background-color', '#F2F2F2')
    #             .css( 'background-size' , 'inherit')

    #   return this
  }