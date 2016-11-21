class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to list_tasks_path(user.lists.first)
    else
      redirect_to '/login', alert: 'Email or password is incorrect!'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login', notice: 'You are logged out!'
  end
end
