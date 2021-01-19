class UsersController < ApplicationController

    get '/registration/signup' do
        erb :'/registration/signup'
    end
    
    post '/registration' do
        user = User.new(params)
        if user.save
          session[:user_id] = user.id
          redirect '/user/home'
        else
          @error = "Invalid credentials"
          erb :'/registration/signup'
        end 
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

end