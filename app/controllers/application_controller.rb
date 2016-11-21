class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_list
    @current_list ||= current_user.lists.find(params[:list_id])
  end

  helper_method :current_list

  def authorize
    redirect_to '/login' unless current_user
  end
end
