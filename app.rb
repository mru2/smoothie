require 'sinatra'

get '/' do
  haml :landing
end