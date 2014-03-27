require 'sinatra'
require "sinatra/reloader" if development?
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'data_mapper'
require 'sinatra/flash'
require 'pp'

enable :sessions
set :session_secret, '*&(^#234)'

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier'], config['secret']
end

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier'], config['secret']
end

# full path!
DataMapper.setup(:default, 
                 ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/database.db" )

class PL0Program
  include DataMapper::Resource
  
  property :name, String, :key => true
  property :source, String, :length => 1..1024
end

  DataMapper.finalize
  DataMapper.auto_upgrade!

helpers do
  def current?(path='/')
    (request.path==path || request.path==path+'/') ? 'class = "current"' : ''
  end
end


get '/grammar' do
  erb :grammar
end

get '/login/?' do
  %Q|<a href='/auth/google_oauth2'>Sign in with Google</a>|
end

get '/:selected?' do |selected|
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
  if name != "test" # check it on the client side
    c  = PL0Program.first(:name => name)
    if c
      c.source = params["input"]
      c.save
    else
      if PL0Program.all.size > 9
        c = PL0Program.all.sample
        c.destroy
      end
      c = PL0Program.create(
        :name => params["fname"], 
        :source => params["input"])
      flash[:notice] = 
        %Q{<div class="success">File saved as #{c.name}.</div>}
    end
  else 
    flash[:notice] = 
      %q{<div class="error">Can't save file with name 'test'.</div>}
  end
  pp c
  redirect '/'
end
