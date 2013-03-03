class SessionsController < ApplicationController
  
  before_filter :redirect_home_if_signed_in, only: [:new, :create]

  def new
  end

  def create    
    user= User.authenticate(params[:session][:email], params[:session][:password])
    if user
      sign_in(user)
      flash[:notice] = "Welcome, #{user.email}!"      
      redirect_to user_path(user)    
    else
      flash[:error] = "Invalid email/password combination"
      redirect_to new_session_path
    end
    
      
  end

  def destroy
    user= current_user
    email=user.email    
    sign_out_user
    
    flash[:notice] = "Logged out #{email}" 
    
    redirect_to root_path
   
  end
  
  
  

end