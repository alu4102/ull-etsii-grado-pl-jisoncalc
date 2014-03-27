$:.unshift "."
require 'sinatra'
require "sinatra/reloader" if development?
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'pl0_program'
require 'sinatra/flash'
require 'pp'

enable :sessions
set :session_secret, '*&(^#234)'
set :reserved_words, %w{grammar test login auth}
set :max_files, 3        # no more than max_files+1 will be saved

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier'], config['secret']
end

helpers do
  def current?(path='/')
    (request.path==path || request.path==path+'/') ? 'class = "current"' : ''
  end
end

get '/grammar' do
  erb :grammar
end

get '/auth/:name/callback' do
  session[:auth] = @auth = request.env['omniauth.auth']
  session[:name] = @auth['info'].name
  session[:image] = @auth['info'].image
  puts "params = #{params}"
  puts "@auth.class = #{@auth.class}"
  puts "@auth info = #{@auth['info']}"
  puts "@auth info class = #{@auth['info'].class}"
  puts "@auth info name = #{@auth['info'].name}"
  puts "@auth info email = #{@auth['info'].email}"
  #puts "-------------@auth----------------------------------"
  #PP.pp @auth
  #puts "*************@auth.methods*****************"
  #PP.pp @auth.methods.sort
  flash[:notice] = 
        %Q{<div class="success">Authenticated as #{@auth['info'].name}.</div>}
  redirect '/'
end

get '/:selected?' do |selected|
  puts "*************@auth*****************"
  puts session[:name]
  pp session[:auth]
  programs = PL0Program.all
  pp programs
  puts "selected = #{selected}"
  c  = PL0Program.first(:name => selected)
  source = if c then c.source else "a = 3-2-1" end
  erb :index, 
      :locals => { :programs => programs, :source => source }
end

post '/save' do
  pp params
  name = params[:fname]
  if session[:auth] # authenticated
    if settings.reserved_words.include? name  # check it on the client side
      flash[:notice] = 
        %Q{<div class="error">Can't save file with name '#{name}'.</div>}
    else 
      c  = PL0Program.first(:name => name)
      if c
        c.source = params["input"]
        c.save
      else
        if PL0Program.all.size >= settings.max_files
          c = PL0Program.all.sample
          c.destroy
        end
        c = PL0Program.create(
          :name => params["fname"], 
          :source => params["input"])
        flash[:notice] = 
          %Q{<div class="success">File saved as #{c.name}.</div>}
      end
      pp c
    end
  else
    flash[:notice] = 
      %Q{<div class="error">You are not authenticated.<br />
         Sign in with Google.
         </div>}
  end
  redirect '/'
end
