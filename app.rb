require 'sinatra/base'

require 'soundcloud_client'
require 'user'
require 'shuffler'
require 'playlist_syncer'

module Smoothie
  class Application < Sinatra::Base

    UserSession = Struct.new(:username, :id, :access_token, :refresh_token)

    enable :sessions, :logging, :dump_errors, :raise_errors, :show_exceptions

    logger = ::File.open("log/sinatra.log", "a+")
    STDOUT.reopen(logger)
    STDERR.reopen(logger)

    Application.use Rack::CommonLogger, logger

    configure do
      set :session_secret, "session_secret" 
    end

    # Landing page
    get '/' do
      if session[:user]
        haml :radio
      else
        haml :landing
      end
    end

    # Soundcloud login
    get '/login' do
      # Create client object with app credentials
      soundcloud = Smoothie::SoundcloudClient.new

      # Redirect user to authorize URL
      redirect soundcloud.client.authorize_url
    end

    # Soundcloud login callback
    get '/login/callback' do

      # Save the user access and refresh tokens in session
      soundcloud = Smoothie::SoundcloudClient.new
      user_token = soundcloud.client.exchange_token :code => params[:code]

      current_user = Smoothie::SoundcloudClient.new(:access_token => user_token.access_token).client.get('/me')

      session[:user] = UserSession.new(
        current_user.username,
        current_user.id,
        user_token.access_token, 
        user_token.refresh_token
      )

      # Fetch its tracks if not already
      Smoothie::PlaylistSyncer.new('id' => session[:user].id, 'limit' => 'all').run

      redirect '/#'
    end

    # Soundcloud logout
    get '/logout' do
      session[:user] = nil

      redirect '/'
    end


    # The playlist
    get '/api/v1/tracks.json' do
      content_type :json

      if !params[:id]
        response.status = 400
        return
      end

      offset = params[:offset].to_i
      limit = params[:limit] ? params[:limit].to_i : 10
      seed = params[:seed] && params[:seed].to_i

      user = Smoothie::User.new(params[:id])
      shuffler = Smoothie::Shuffler.new(user.track_ids.members, seed)
      shuffled_tracks = shuffler.get(:offset => offset, :limit => limit)

      {:seed => shuffler.seed.to_s, :tracks => shuffled_tracks}.to_json
    end

    # 404 not found
    not_found do
      erb :'404', :layout => nil
    end

  end
end