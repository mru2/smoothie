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

      console.log 'initialized tracks view : ', @previousTrackView, @currentTrackView, @nextTrackView

    # Events
    # tracks:trackClicked(track) : a track has been clicked (to be played next)


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



    # Private




    # tracks_container: '#tracks'

    # events: {
    #   "click .track.previous": "onPrevious",
    #   "click .track.next": "onNext"
    # }

    # bootstrap: () ->
    #   @$el.find(@tracks_container).html('')
    #   this.buildPreviousTrack()
    #   this.buildCurrentTrack()
    #   this.buildNextTrack()

    #   @controls = new ControlsView({el: "#controls-container"})
    #   this.render()

    # Move the tracks
    # moveTracksForward: () ->
    #   @previousTrack.unbind().remove()

    #   @previousTrack = @currentTrack
    #   @previousTrack.$el.removeClass('current').addClass('previous')

    #   @currentTrack = @nextTrack
    #   @currentTrack.$el.removeClass('next').addClass('current')

    #   this.buildNextTrack()

    # moveTracksBackward: () ->
    #   @nextTrack.unbind().remove()

    #   @nextTrack = @currentTrack
    #   @nextTrack.$el.removeClass('current').addClass('next')

    #   @currentTrack = @previousTrack
    #   @currentTrack.$el.removeClass('previous').addClass('current')

    #   this.buildPreviousTrack()


    # Building tracks
    # buildTrack: (id, elClass) ->
    #   trackView = new TrackView {
    #     className: "track #{elClass}", 
    #     track_id: id
    #   }
    #   trackView.$el.css('opacity', '0')
    #   @$el.find(@tracks_container).append(trackView.render().el)
    #   setTimeout (() -> trackView.$el.css('opacity', '')), 0

    #   return trackView

    # buildPreviousTrack: () ->
    #   @previousTrack = this.buildTrack(Playlist.getPreviousTrack(), 'previous')

    # buildCurrentTrack: () ->
    #   @currentTrack = this.buildTrack(Playlist.getCurrentTrack(), 'current')

    # buildNextTrack: () ->
    #   @nextTrack = this.buildTrack(Playlist.getNextTrack(), 'next')


    # Events handlers
    # onPrevious: () ->
    #   @controls.onPrevious() 

    # onNext: () ->
    #   @controls.onNext() 

    # Render (updating controls)
    # render: () ->
    #   @controls.render()
  }
