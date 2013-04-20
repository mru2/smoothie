PlayerView = Backbone.View.extend {
  
  el: '#current-track'

  tracks_container: '#tracks'

  events: {
    "click .track.previous": "onPrevious",
    "click .track.next": "onNext"
  }


  bootstrap: () ->
    this.buildPreviousTrack()
    this.buildCurrentTrack()
    this.buildNextTrack()

    @controls = new Smoothie.Views.ControlsView({el: "#controls"})
    this.render()

  # Move the tracks
  moveTracksForward: () ->
    @previousTrack.unbind().remove()

    @previousTrack = @currentTrack
    @previousTrack.$el.removeClass('current').addClass('previous')

    @currentTrack = @nextTrack
    @currentTrack.$el.removeClass('next').addClass('current')

    this.buildNextTrack()

  moveTracksBackward: () ->
    @nextTrack.unbind().remove()

    @nextTrack = @currentTrack
    @nextTrack.$el.removeClass('current').addClass('next')

    @currentTrack = @previousTrack
    @currentTrack.$el.removeClass('previous').addClass('current')

    this.buildPreviousTrack()


  # Building tracks
  buildTrack: (id, elClass) ->
    trackView = new Smoothie.Views.TrackView {
      className: "track #{elClass}", 
      track_id: id
    }
    trackView.$el.css('opacity', '0')
    @$el.find(@tracks_container).append(trackView.render().el)
    setTimeout (() -> trackView.$el.css('opacity', '')), 0

    return trackView

  buildPreviousTrack: () ->
    @previousTrack = this.buildTrack(Smoothie.Modules.Playlist.getPreviousTrack(), 'previous')

  buildCurrentTrack: () ->
    @currentTrack = this.buildTrack(Smoothie.Modules.Playlist.getCurrentTrack(), 'current')

  buildNextTrack: () ->
    @nextTrack = this.buildTrack(Smoothie.Modules.Playlist.getNextTrack(), 'next')


  # Events handlers
  onPrevious: () ->
    @controls.onPrevious() 

  onNext: () ->
    @controls.onNext() 

  # Render (updating controls)
  render: () ->
    @controls.render()

}


Smoothie.Views.PlayerView = new PlayerView
