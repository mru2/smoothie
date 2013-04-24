# Tracks View
# Since only three tracks are displayed at any given time,
# this view is responsible for their displaying and reordering

define ['backbone',
        'mediator',
        'smoothie/views/track_view'], \

        (Backbone, Mediator, TrackView) ->

  TracksView = Backbone.View.extend {
    
    # el: '#current-track'
    el: '#tracks'


    # Events
    # tracks:trackClicked(track) : a track has been clicked (to be played next)


    # Move the tracks forward and append a new one in the end
    moveForward: (lastTrack) ->


    # Move the tracks backward and append a new one in the beginning
    moveBackward: (firstTrack) ->


    # Render the tracks
    render: () ->


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
