require.config
  baseUrl: "/js/"

  paths:
    jquery: 'vendor/jquery-1.9.0.min'
    underscore: 'vendor/underscore-1.4.4.min',
    backbone: 'vendor/backbone-1.0.0.min'

  shim:
    underscore:
      exports: "_"

    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'


require ['smoothie/views/player_view'], (PlayerView) ->
  player_view = new PlayerView
  player_view.bootstrap()


# window.Smoothie = {
#   Models: {},
#   Views: {},
#   Modules: {},
# }


# # Initializing
# $ () ->

#   # Soundcloud initialization
#   SC.accessToken(window.session.accessToken)

#   # SC.connect () -> 
#   Smoothie.Modules.Playlist.init window.session.userId, () -> 
#     Smoothie.Views.PlayerView.bootstrap()

