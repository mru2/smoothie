# Player view
# Handles the rendering of the player

define ['backbone',
        'jquery',
        'underscore',
        'smoothie/models/track'], \

        (Backbone, $, _, Track) ->

  PlayerView = Backbone.View.extend {

    template: 
      '<div id="player">' +
        '<div class="artwork"></div>' +
        '<div class="content">' + 
          '<a class="title" href="<%= track.permalink_url %>" target="_blank"><%= track.title %></a>' +
          '<a class="artist" href="<%= track.user_permalink %>"><%= track.username %></a>' +
          '<div id="controls">' +
            '<% if (playing) { %>' +
              '<a class="control" id="pause"><i class="icon-pause"></i></a>' +
            '<% } else { %>' +
              '<a class="control" id="play"><i class="icon-play"></i></a>' +
            '<% } %>' +
            '<a class="control" id="prev"><i class="icon-step-backward"></i></a>' +
            ' ' + # Whitespace for spacing between prev and next controls
            '<a class="control" id="next"><i class="icon-step-forward"></i></a>' +
          '</div>' +
        '</div>' +
      '</div>'


    # Constructor
    initialize: () ->
      # The associated pubsub to forward events to
      @pubsub = @options.pubsub

      # The playing status
      @playing = @options.playing

      this.render() if @model


    # Updates the current track
    setTrack: (track) ->
      @model = track
      this.render()


    # Updates the playing status (paused or playing)
    setPlaying: (playing) ->
      @playing = playing
      this.render()


    # Rendering
    render: () ->
      # Render the template with the current track and playing status
      @$el.html( _.template @template, {track: @model.attributes, playing: @playing} )

      # Set the background according to the artwork
      artwork= @$el.find('.artwork')

      if @model.get('artwork_url')

        # Load the background image asynchronously, and display it when ready
        $('<img/>').attr('src', @model.get('artwork_url')).load () =>
          artwork.css( 'background-image',  "url(#{@model.get('artwork_url')})" )
                 .css( 'background-size',   'cover' )

      else
        artwork.css( 'background-image', 'url(/images/default-track-bg.png)')
               .css( 'background-color', '#F2F2F2')


    # Events and handlers
    events: {
      "click #play":  "onClickedPlay"
      "click #pause": "onClickedPause"
      "click #prev":  "onClickedPrev"
      "click #next":  "onClickedNext"
    }

    onClickedPlay:  () -> @pubsub.trigger 'player:play'
    onClickedPause: () -> @pubsub.trigger 'player:pause'
    onClickedPrev:  () -> @pubsub.trigger 'player:previous'
    onClickedNext:  () -> @pubsub.trigger 'player:next'

  }




# .artwork
# .content
#   %a.title
#   %a.artist
#   #controls
#     %a#play.control
#       %i.icon-play
#     %a#prev.control
#       %i.icon-step-backward
#     %a#next.control
#       %i.icon-step-forward
