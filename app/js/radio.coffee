# The JS app for the radio

require.config

  # Disable the timeout for now, until yeoman is fully integrated in the frontend
  waitSeconds: 0

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



require ['jquery', 'smoothie/modules/soundcloud', 'smoothie/controllers/radio_controller'], ($, Soundcloud, RadioController) ->

  $ () ->

    # Soundcloud initialization
    # There because authentication still done server-side
    # When the radio becomes a full-fledged singlepage app, this should be
    # Handled in the auth callback
    Soundcloud.initialize {
      access_token: window.session.accessToken
    }

    # Boostraping the app
    RadioController.initialize {
      user_id: window.session.userId      
    }



# # Initializing
# $ () ->


#   # SC.connect () -> 
#   Smoothie.Modules.Playlist.init window.session.userId, () -> 
#     Smoothie.Views.PlayerView.bootstrap()

