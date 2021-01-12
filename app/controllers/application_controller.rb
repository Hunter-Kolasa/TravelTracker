require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  #main page for login/signup
  get "/" do
    erb :home
  end


  get '/registration/signup' do
    erb :'/registration/signup'
  end

  post '/registration' do
    user = User.new(params)
    if user.name.empty? || user.email.empty? || user.password_digest.nil?
      @error = "You need to enter a name, email and password to sign-up!"
      erb :'/registration/signup'
    elsif User.find_by(email: user.email.downcase)
      @error = "That email already exists with us!"
      erb :'/registration/signup'
    else
      user.email = user.email.downcase
      user.save(params)
      session[:user_id] = user.id
      redirect '/user/home'
    end 
  end

  get '/sessions/login' do  
    erb :'sessions/login'
  end

  #finds user by their email then authenticates password before continuing
  #displays error page if 
  post '/sessions' do
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/user/home'
    elsif user
      @error = "Incorrect password"
      erb :'sessions/login'
    else
      @error = "Your email isn't registered with us!"
      erb :'sessions/login'
    end
  end

  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

  get '/user/home' do
    if logged_in?
      @user = User.find(session[:user_id])
      @vacations = Vacation.select{|v| v.user_id == session[:user_id]}
      erb :'/user/home'
    else
      redirect '/'
    end
  end

  get '/vacations/all' do
    if logged_in?
      @vacations = Vacation.select{|v| v.user_id == session[:user_id]}
      erb :'/vacations/all'
    else
      redirect 'sessions/login'
    end
  end

  #new request for new vacation
  get '/vacations/new' do
    if logged_in?
      erb :'vacations/new'
    else
      redirect '/sessions/login'
    end
  end

  
  get '/vacations/show/:id' do
    if logged_in?
      @vacation = Vacation.find(params[:id])
      erb :'/vacations/show'
    else
      redirect '/sessions/login'
    end
  end

  #creates new Vacation instance out of recieved params
  #sends instance data to /vacations/show
  post '/vacations/show/:id' do
    if params[:title].empty? || params[:description].empty?
      @error = "Please fill in a title and description"
      erb :'/vacations/new'
    else
      @vacation = Vacation.create(title: params[:title], location: params[:location], date: params[:date], description: params[:description], user_id: session[:user_id])
      erb :'/vacations/show'
    end
  end

  get '/vacations/:id/edit' do
    if logged_in?
      @vacation = Vacation.find(params[:id])
      erb :'vacations/edit'
    else
      redirect '/sessions/login'
    end
  end

  patch '/vacations/show/:id' do
    if params[:title].empty? || params[:description].empty?
      @vacation = Vacation.find(params[:id])
      @error = "Please fill in a title and description"
      erb :'/vacations/edit'
    else
      @vacation = Vacation.find(params[:id])
      @vacation.update(title: params[:title], location: params[:location], date: params[:date], description: params[:description])
      erb :'/vacations/show'
    end
  end

  #Destroy->send delete request to vacations/show with params
  delete '/vacations/show/:id' do
    if logged_in?
      vacation = Vacation.find(params[:id])
      vacation.destroy
      redirect '/user/home'
    else 
      redirect '/sessions/login'
    end
  end

  def logged_in?
    User.find_by(id: session[:user_id])
  end
end
