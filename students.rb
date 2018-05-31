require 'sinatra'
require 'sinatra/reloader'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/database.db")

class Student
	include DataMapper::Resource
    property :student_id, Serial
	property :FirstName, String
	property :LastName, String
	property :Address, String
	property :DateOfBirth, Date
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/students' do
	@students = Student.all
	@title = "Student Information Page"
	erb :students
end

get '/students/new' do
	if session[:isStarted]==true
		@student=Student.new
		erb :create_student
	else
		redirect to('/login')
	end
end

get '/students/:student_id' do
	@student = Student.get(params[:student_id])
	erb :show_student
end

post '/students' do  
  student = Student.create(params[:stud])
  student.save
  redirect to("/students/#{student.student_id}")
end

post '/students/:student_id' do
	if session[:isStarted]==true
		student=Student.get(params[:student_id])
		student.update(params[:stud])
		redirect to("/students/#{student.student_id}")
	else
		redirect to('/login')
	end
end

get '/students/:student_id/edit' do
	if session[:isStarted]==true
		@student = Student.get(params[:student_id])
		erb :edit_student
	else
		redirect to('/login')
	end
end

delete '/students/:student_id' do
	if session[:isStarted]==true
  		Student.get(params[:student_id]).destroy
		redirect to('/students')
	else
		redirect to('/login')
	end	
end

