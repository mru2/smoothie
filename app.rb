require 'sinatra/base'

require 'soundcloud_client'
require 'user'
require 'playlist_builder'

module Smoothie
  class Application < Sinatra::Base

    # UserSession = Struct.new(:username, :id, :access_token, :refresh_token)
    # enable :sessions, :logging, :dump_errors, :raise_errors, :show_exceptions

    logger = ::File.open("log/sinatra.log", "a+")
    Application.use Rack::CommonLogger, logger

    configure do
      # set :session_secret, "session_secret" 
      set :public_folder, ENV['RACK_ENV'] == 'production' ? 'public' : '.tmp'  
    end

    get '/' do
      send_file File.join(settings.public_folder, 'index.html')
    end

    # The playlist
    get '/api/v1/tracks.json' do
      content_type :json

      # Checking a user is provided
      if !params[:id]
        response.status = 400
        return
      end

      user     = Smoothie::User.new(params[:id])
      playlist = Smoothie::PlaylistBuilder.new(user, params[:seed])

      return {
        :seed   => playlist.seed,
        :tracks => playlist.track_ids(:limit => params[:limit], :offset => params[:offset])
      }.to_json
    end

  end
end