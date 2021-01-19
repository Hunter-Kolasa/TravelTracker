class VacationsController < ApplicationController

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
          erb :'/vacations/show'
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

end