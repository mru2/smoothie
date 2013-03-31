PlayerView = Backbone.View.extend {
  
  el: '#current-track'
  tracks_container: '#tracks'

  initialize: (TrackView, ControlsView, Playlist, PubSub) ->
    console.log 'Initializing PlayerView'

    # Creating subviews
    @previousTrack  = new TrackView {
      className: 'track previous', 
      model: Playlist.getPreviousTrack()
    }

    @currentTrack = new TrackView {
      className: 'track current',
      model: Playlist.getCurrentTrack()
    }

    @nextTrack = new TrackView {
      className: 'track next',
      model: Playlist.getNextTrack()
    }

    @controls = new ControlsView({el: "#controls"})


    # Binding events
    @listenTo PubSub, 'application:init', @onInit


  # Callbacks
  onInit: () ->
    console.log 'PlayerView received onInit message'
    @render()


  # Rendering
  render: () ->
    console.log 'Rendering PlayerView'
    tracksContainer = @$el.find(@tracks_container)

    # tracksContainer.html('')
    # tracksContainer.append @previousTrack.render()
    # tracksContainer.append @currentTrack.render()
    # tracksContainer.append @nextTrack.render()

    @controls.render()

    this
}


Smoothie.Views.PlayerView = new PlayerView(
  Smoothie.Views.TrackView, 
  Smoothie.Views.ControlsView, 
  Smoothie.Modules.Playlist,
  Smoothie
)