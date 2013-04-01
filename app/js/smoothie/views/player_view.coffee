PlayerView = Backbone.View.extend {
  
  el: '#current-track'

  tracks_container: '#tracks'

  bootstrap: () ->
    console.log 'Initializing PlayerView'

    @buildPreviousTrack()
    @buildCurrentTrack()
    @buildNextTrack()

    @controls = new Smoothie.Views.ControlsView({el: "#controls"})
    @render()

  # Move the tracks
  moveTracksForward: () ->
    console.log 'Moving tracks forward'

    @previousTrack.unbind().remove()

    @previousTrack = @currentTrack
    @previousTrack.$el.removeClass('current').addClass('previous')

    @currentTrack = @nextTrack
    @currentTrack.$el.removeClass('next').addClass('current')

    @buildNextTrack()

  moveTracksBackward: () ->
    console.log 'moving tracks backward'

    @nextTrack.unbind().remove()

    @nextTrack = @currentTrack
    @nextTrack.$el.removeClass('current').addClass('next')

    @currentTrack = @previousTrack
    @currentTrack.$el.removeClass('previous').addClass('current')

    @buildPreviousTrack()


  # Building tracks
  buildPreviousTrack: () ->
    @previousTrack  = new Smoothie.Views.TrackView {
      className: 'track previous', 
      model: Smoothie.Modules.Playlist.getPreviousTrack()
    }
    @$el.find(@tracks_container).append(@previousTrack.render().el)

  buildCurrentTrack: () ->
    @currentTrack = new Smoothie.Views.TrackView {
      className: 'track current',
      model: Smoothie.Modules.Playlist.getCurrentTrack()
    }
    @$el.find(@tracks_container).append(@currentTrack.render().el)

  buildNextTrack: () ->
    @nextTrack = new Smoothie.Views.TrackView {
      className: 'track next',
      model: Smoothie.Modules.Playlist.getNextTrack()
    }
    @$el.find(@tracks_container).append(@nextTrack.render().el)


  # Render (updating controls)
  render: () ->
    @controls.render()

}


Smoothie.Views.PlayerView = new PlayerView
