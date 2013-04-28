# Tracks View
# Since only three tracks are displayed at any given time,
# this view is responsible for their displaying and reordering

define ['backbone',
        'smoothie/views/track_view'], \

        (Backbone, TrackView) ->

  TracksView = Backbone.View.extend {
    
    el: '#tracks'

    initialize: () ->
      @pubsub             = @options.pubsub
      @previousTrackView  = new TrackView({model: @options.previousTrack,  className:'track previous'}) if @options.previousTrack
      @currentTrackView   = new TrackView({model: @options.currentTrack,   className:'track current'})  if @options.currentTrack
      @nextTrackView      = new TrackView({model: @options.nextTrack,      className:'track next'})     if @options.nextTrack


    # Move the tracks forward and append a new one in the end
    moveForward: (lastTrack) ->
      @previousTrackView.unbind().remove() if @previousTrackView

      @previousTrackView = @currentTrackView
      @previousTrackView.$el.removeClass('current').addClass('previous')

      @currentTrackView = @nextTrackView
      @currentTrackView.$el.removeClass('next').addClass('current')

      @nextTrackView = new TrackView({model: lastTrack, className: 'track next'})
      @$el.append @nextTrackView.render().el


    # Move the tracks backward and append a new one in the beginning
    moveBackward: (firstTrack) ->
      @nextTrackView.unbind().remove() if @nextTrackView

      @nextTrackView = @currentTrackView
      @nextTrackView.$el.removeClass('current').addClass('next')

      @currentTrackView = @previousTrackView
      @currentTrackView.$el.removeClass('previous').addClass('current')

      @previousTrackView = new TrackView({model: firstTrack,  className:'track previous'})
      @$el.prepend @previousTrackView.render().el


    # Render the tracks
    render: () ->
      @$el.html('')
      @$el.append @previousTrackView.render().el if @previousTrackView
      @$el.append @currentTrackView.render().el if @currentTrackView
      @$el.append @nextTrackView.render().el if @nextTrackView


    # Events
    events: {
      "click .track.previous":  "onClickedPreviousTrack"
      "click .track.next":      "onClickedNextTrack"
    }

    # Events handlers
    onClickedPreviousTrack: () ->
      @pubsub.trigger 'tracks:clicked_previous'

    onClickedNextTrack: () ->
      @pubsub.trigger 'tracks:clicked_next'

  }
