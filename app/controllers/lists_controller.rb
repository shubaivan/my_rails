class ListsController < ApplicationController
  def index
    @user = current_user
    @list = List.new
  end

  def shared
    @user = current_user
  end

  def create
    @list = List.new(list_params)
    @list.user= current_user
    @user_ids = user_params

    create_lists_user @user_ids[:users], @list
    render(:new) unless @list.save
  end

  def update
    @list = List.find(params[:id])
    create_lists_user user_params[:users], @list
    if @list.update_attributes(list_params)
      flash[:success] = "Lists updated"
      redirect_to lists_path
    else
      render 'edit'
    end
  end

  def edit
    @list = List.find(params[:id])
  end

  def custom_edit
    @list = List.find(params[:id])
  end

  def custom_update
    @list = List.find(params[:id])
    @user = User.find_by(email: params[:email])
    if @user
      create_lists_user [@user], @list
      UserNotifierMailer.send_signin_email(@user).deliver
      flash[:success] = "find user"
      redirect_to lists_path
    else
      UserNotifierMailer.send_signup_email(params[:email], @list).deliver
      flash[:success] = "empty user"
      redirect_to my_edit_path
    end
  end

  def list_params
    params.require(:list).permit(:title)
  end

  def user_params
    params.require(:list).permit(:users => [])
  end

  private

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

  def shared_users
    @users ||= User.shared_user(current_user)
  end

  def shared_users_include_lists
    @users ||= User.include_current_user(current_user, include_lists)
  end

  def include_lists
    @list = List.find_by(id: params[:id])
  end

  helper_method :shared_users, :shared_users_include_lists
end
