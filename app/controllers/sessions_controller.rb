class SessionsController < ApplicationController

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
end