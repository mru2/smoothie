Smoothie.Modules.Player = {

  playing: false

  track: null

  play: () ->
    @playing = true
    Smoothie.Views.PlayerView.render()

  pause: () ->
    @playing = false
    Smoothie.Views.PlayerView.render()
}