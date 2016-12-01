class UsersController < ApplicationController
  before_action :user_find_id, only: [:show, :update, :edit]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if params[:user][:list_id]
        @list = List.find_by(id: params[:user][:list_id])
        if @list
          create_lists_user [@user], @list
        end
      end
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  private

  def user_find_id
    @user = User.find(params[:id])
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end

  def create_lists_user(user_ids, list)
    user_ids.each do |item|
      if item.is_a?(User)
        user_object = item
      else
        user_object = User.find_by(id: item)
      end

      if user_object
        @lists_user = ListsUser.new
        @lists_user.user = user_object
        @lists_user.list = list
        @lists_user.save
      end
    end
  end
end
