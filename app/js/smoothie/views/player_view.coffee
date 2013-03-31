PlayerView = Backbone.View.extend {
  
  el: '#current-track'

  initialize: () ->
    # Creating subviews
    @previousTrack  = new TrackView({className: 'previous'})
    @currentTrack   = new TrackView({className: 'current'})
    @nextTrack      = new TrackView({className: 'next'})
      
    @controls       = new ControlsView({el: "#controls"})

    # Binding events
    Smoothie.bind 'smoothie:init', @onInit, this


  onInit: () ->
    console.log 'PlayerView received onInit message'
    @render()

  render: () ->
    console.log 'rendering PlayerView!'
    this
}

Smoothie.Views.PlayerView = new PlayerView