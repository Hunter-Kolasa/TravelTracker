require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

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

  post '/sessions' do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/user/home'
    else
      erb :failed
    end
  end

  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

  get '/user/home' do
    @user = User.find(session[:user_id])
    erb :'/user/home'
  end

end
