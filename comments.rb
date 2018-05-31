require 'sinatra'
require 'sinatra/reloader'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/database.db")

class Comment

	include DataMapper::Resource
	property :comment_id, Serial
	property :comment, String
	property :name, String
	property :created_at, Time
end

DataMapper.finalize
DataMapper.auto_upgrade!


get '/comments/new' do
    if session[:isStarted]==true
	    @comment=Comment.new
        erb :create_comment
    else
		redirect to('/login')
	end
end

get '/comments/:id' do
	@comment = Comment.get(params[:comment_id])
	erb :show_comment
end

delete '/comments/:comment_id' do
	if session[:isStarted]==true
  		Comment.get(params[:comment_id]).destroy
		redirect to('/comments')
	else
		redirect to('/login')
	end		
end

post '/comments' do  
  comment = Comment.create(params[:comment])
  comment.save
  redirect to("/comments/#{comment.comment_id}")
end

get '/comments/:comment_id/viewdetails' do
	@comment=Comment.get(params[:comment_id])
	erb :show_comment
end