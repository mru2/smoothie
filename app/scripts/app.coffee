# The JS app for the radio
require.config
  baseUrl: "/scripts/"
  paths:
    jquery: "../components/jquery/jquery"
    underscore: "../components/underscore/underscore"
    backbone: "../components/backbone/backbone"
    mustache: "../components/mustache/mustache"
    when: "../components/when/when"
    soundcloudSdk: "//connect.soundcloud.com/sdk"
    jqueryCookie: "../components/jquery.cookie/jquery.cookie"

  shim:
    soundcloudSdk:
      exports: "SC"

    underscore:
      exports: "_"

    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone"

    jqueryCookie: ['jquery']



define ['jquery', 'underscore', 'smoothie/modules/soundcloud', 'smoothie/controllers/radio_controller', 'jqueryCookie'], \

       ($, _, Soundcloud, RadioController) ->


  "use strict"

  window.App = {

    # The container
    container: '#main-container .container'

    # The loading screen (default)
    renderLoading: () ->
      $(@container).html('<i id="loader" class="icon-refresh icon-spin"></i>')

    # The landing page
    renderLanding: () ->
      $.get 'templates/landing.html', (template) =>
        $(@container).html(template)

    # The radio page
    renderRadio: () ->
      # Fix : initialize a SC stream to load the lib
      SC.stream('/tracks/1')

      SC.get '/me', (user) =>
        RadioController.initialize { 
          userId: user.id
          container: @container
        }

    # The login logic
    login: () ->
      SC.connect () =>
        $.cookie('sc_token', SC.accessToken())
        this.renderRadio()

  }

  $ ->

    Soundcloud.initialize()

    # To persist the login on refresh
    if $.cookie('sc_token')
      SC.accessToken($.cookie('sc_token'))
      App.renderRadio()

    # Default landing
    else
      App.renderLanding()
