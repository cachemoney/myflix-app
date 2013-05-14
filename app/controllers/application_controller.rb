class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_user
  	redirect_to sign_in_path unless current_user
  end
  
  def current_user
  	User.find(session[:user_id]) if session[:user_id] #if statement is used, user.find(nil) returns an error
  end

  # This is done so that this can be called in the views
  helper_method	:current_user
end
