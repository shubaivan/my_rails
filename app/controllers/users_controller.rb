class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      user = User.authenticate(params[:user][:email], params[:user][:password])
      if user
        session[:user_id] = user.id
        redirect_to root_url, :notice => "Logged in!"
      else
        flash.now.alert = "Invalid email or password"
        render "new"
      end
      # redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end

  def user_params
    params.require(:user).permit(
        :email, :password_confirmation, :password, :password_salt, :password_hash
    )
  end
end
