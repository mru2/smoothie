// The JS app for the radio
require.config({

    baseUrl: '/scripts/',

    paths: {
        jquery: '../components/jquery/jquery',
        underscore: '../components/underscore/underscore',
        backbone: '../components/backbone/backbone',
        mustache: '../components/mustache/mustache',
        when: '../components/when/when',
        soundcloudSdk: 'vendor/soundcloud-sdk'
    },

    shim: {
        soundcloudSdk: {
            exports: 'SC'
        },

        underscore: {
            exports: '_'
        },

        backbone: {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        }
    }

});



require(['jquery', 'smoothie/modules/soundcloud', 'smoothie/controllers/radio_controller'], function($, Soundcloud, RadioController){

    'use strict';

    $(function(){

        // Soundcloud initialization
        // There because authentication still done server-side
        // When the radio becomes a full-fledged singlepage app, this should be
        // Handled in the auth callback
        Soundcloud.initialize({
            accessToken: window.session.accessToken
        });

        // Boostraping the app
        RadioController.initialize({
            userId: window.session.userId
        });

    });
});


