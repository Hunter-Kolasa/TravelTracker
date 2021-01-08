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
    @user = User.find_by(email: params[:email])
    if @user
      erb :'registration/account_exists'
    else
      if params[:password] == "" || params[:name] == "" || params[:email] == ""
        erb :failed
      else
        @user = User.create(name: params[:name], email: params[:email], password: params[:password])
        session[:user_id] = @user.id
        redirect '/user/home'
      end
    end 
  end

  get '/sessions/login' do  
    erb :'sessions/login'
  end

  #finds user by their email then authenticates password before continuing
  #displays error page if 
  post '/sessions' do
    
    user = User.find_by(email: params[:email])
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
    @user = User.find(session[:user_id])
    @vacations = Vacation.select{|v| v.user_id == session[:user_id]}
    erb :'/user/home'
  end
  
  #new request for new vacation
  get '/vacations/new' do
    erb :'vacations/new'
  end

  get '/vacations/show/:id' do
    @vacation = Vacation.find(params[:id])
    erb :'/vacations/show'
  end

  #creates new Vacation instance out of recieved params
  #sends instance data to /vacations/show
  post '/vacations/show/:id' do
    @vacation = Vacation.create(title: params[:title], location: params[:location], date: params[:date], description: params[:description], user_id: session[:user_id])
    erb :'/vacations/show'
  end

  get '/vacations/:id/edit' do
    @vacation = Vacation.find(params[:id])
    erb :'vacations/edit'
  end

  patch '/vacations/show/:id' do
    @vacation = Vacation.find(params[:id])
    @vacation.update(title: params[:title], location: params[:location], date: params[:date], description: params[:description])
    erb :'/vacations/show'
  end

  #Destroy->send delete request to vacations/show with params
  delete '/vacations/show/:id' do
    vacation = Vacation.find(params[:id])
    vacation.destroy
    redirect '/user/home'
  end

end
