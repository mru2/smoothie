PlayerView = Backbone.View.extend {
  
  el: '#current-track'

  tracks_container: '#tracks'

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
  buildTrack: (model, class) ->
    trackView = new Smoothie.Views.TrackView {
      className: "track #{class}", 
      model: model
    }
    @$el.find(@tracks_container).append(trackView.render().el)
    return trackView

  buildPreviousTrack: () ->
    @previousTrack = this.buildTrack(Smoothie.Modules.Playlist.getPreviousTrack(), 'previous')

  buildCurrentTrack: () ->
    @currentTrack = this.buildTrack(Smoothie.Modules.Playlist.getCurrentTrack(), 'current')

  buildNextTrack: () ->
    @nextTrack = this.buildTrack(Smoothie.Modules.Playlist.getNextTrack(), 'next')


  # Render (updating controls)
  render: () ->
    @controls.render()

}


Smoothie.Views.PlayerView = new PlayerView
