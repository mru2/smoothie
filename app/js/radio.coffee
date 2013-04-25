# The JS app for the radio

require.config
  baseUrl: "/js/"

  paths:
    jquery: 'vendor/components/jquery/jquery'
    underscore: 'vendor/components/underscore/underscore',
    backbone: 'vendor/components/backbone/backbone',
    mustache: 'vendor/components/mustache/mustache',
    when: 'vendor/components/when/when',
    soundcloud_sdk: 'vendor/soundcloud-sdk'



  shim:
    soundcloud_sdk:
      exports: 'SC'

    underscore:
      exports: "_"

    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'



require ['jquery', 'soundcloud_sdk', 'smoothie/controllers/radio_controller'], ($, SC, RadioController) ->
  $ () ->
    # Soundcloud initialization
    SC.accessToken(window.session.accessToken)

    # Boostraping the app
    RadioController.bootstrap()



# # Initializing
# $ () ->


#   # SC.connect () -> 
#   Smoothie.Modules.Playlist.init window.session.userId, () -> 
#     Smoothie.Views.PlayerView.bootstrap()

