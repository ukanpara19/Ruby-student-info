require 'sinatra'
require 'sinatra/reloader'
require 'sass'
require './students.rb'
require './comments.rb'
require 'dm-timestamps'
require 'bundler/setup'


configure do
	enable :sessions
	set :password, "utsav@123"
  set :username, "utsav"
end

helpers do 
	def isStarted?
		session[:isStarted]
	end
end

get '/' do
  @title = "Student Information System"
  erb :home_page 
end

get '/about' do
  @title = "About"
  erb :about
end

get '/contact' do
  @title = "Contact"
  erb :contact
end

get '/comments' do
  @comments = Comment.all
  @title = "Comments"
  erb :comments
end

get '/login' do
  @title = "Login"
  erb :login
end

post '/login' do
	if params[:username]==settings.username && params[:password]==settings.password
    session[:isStarted]=true
    erb :post_login
	else
		erb :incorrect_login
	end
end

get '/logout' do
  session[:isStarted]=false
  session.clear
  erb :home_page
end

get '/video' do
  @title = "Student Information Page"
  erb :video
end

not_found do
  @title = "Student Information Page"
  erb :notfound
end

get '/style.css' do
  scss :style
end