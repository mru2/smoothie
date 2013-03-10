require 'sinatra/base'
require 'sinatra/assetpack'

module Smoothie
  class Application < Sinatra::Base

    # Assets handling
    register Sinatra::AssetPack

    assets do
      css :application, [
        'css/normalize.css',
        'css/bootstrap.css',
        'css/bootstrap-responsive.css',
        'css/font-awesome.css',
        'css/flat-ui.css',
        'css/smoothie.css'
      ]

      js :app, [
        'js/vendor/jquery-1.9.0.min.js',
        'js/vendor/modernizr-2.6.2.min.js',
        'js/vendor/console.js',
        'js/application.js'
      ]
    end

    # Landing page
    get '/' do
      haml :landing
    end

    # The player
    get '/radio' do
      haml :radio
    end

  end
end