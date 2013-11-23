# Player view
# Handles the rendering of the player

define ['backbone',
        'jquery',
        'underscore',
        'smoothie/models/track'], \

        (Backbone, $, _, Track) ->

  PlayerView = Backbone.View.extend {

    template: 
      '<div id="player">
        <div class="details">

          <div class="topleft">
            <a class="control" id="togglePlaylist"><i class="icon-undo"></i></a>
          </div>

          <div class="info">

            <a class="title" href="<%= track.permalink_url %>" target="_blank"><%= track.title %></a>

            <a class="artist" href="<%= track.user_permalink %>" target="_blank"><%= track.username %></a>

            <div class="controls">
              <a class="control" id="prev"><i class="icon-backward"></i></a>
              <% if (playing) { %>
                <a class="control" id="pause"><i class="icon-pause"></i></a>
              <% } else { %>
                <a class="control" id="play"><i class="icon-play"></i></a>
              <% } %>
              <a class="control" id="next"><i class="icon-forward"></i></a>
            </div>

            <div id="player-bar"><span></span></div>

          </div>

          <div class="bottomright">
            <% if (track.liked) { %>
              <a id="unlike" class="control"><i class="icon icon-heart"></i></a>
            <% } else { %>
              <a id="like" class="control"><i class="icon icon-heart"></i></a>
            <% } %>
          </div>
        </div>

        <div class="artwork">

        </div>
      </div>'


    noTracksTemplate: 
      '<div class="landing">' +
        '<h1>Your tracks are being fetched...</h1>' +
        '<p>Please reload the page in a couple of minutes.</p>' +
      '</div>'

    errorTemplate: 
      '<div class="landing">' +
        '<h1>An error occured...</h1>' +
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


    # Update the track position
    setPosition: (position) ->
      @$el.find('#player-bar span').css('width', (position*100) + '%')


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

    renderNoTracks: () ->
      @$el.html(@noTracksTemplate)

    renderError: () ->
      @$el.html(@errorTemplate)

    # Events and handlers
    events: {
      "click #play":            "onClickedPlay"
      "click #pause":           "onClickedPause"
      "click #prev":            "onClickedPrev"
      "click #next":            "onClickedNext"
      "click #like":            "onClickedLike"
      "click #unlike":          "onClickedUnlike"
      "click #togglePlaylist" : "onClickedTogglePlaylist"
    }

    onClickedPlay:            () -> @pubsub.trigger 'player:play'
    onClickedPause:           () -> @pubsub.trigger 'player:pause'
    onClickedPrev:            () -> @pubsub.trigger 'player:previous'
    onClickedNext:            () -> @pubsub.trigger 'player:next'
    onClickedLike:            () -> @pubsub.trigger 'player:like'
    onClickedUnlike:          () -> @pubsub.trigger 'player:unlike'
    onClickedTogglePlaylist:  () -> @pubsub.trigger 'player:toggle_playlist'

  }
