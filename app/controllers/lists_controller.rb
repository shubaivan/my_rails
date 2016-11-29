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

  def list_params
    params.require(:list).permit(:title)
  end

  def user_params
    params.require(:list).permit(:users => [])
  end

  private

  def create_lists_user(user_ids, list)
    user_ids.each do |item|
      user_object = User.find_by(id: item)
      if user_object
        @lists_user = ListsUser.new
        @lists_user.user = user_object
        @lists_user.list = list
        @lists_user.save
      end
    end
  end

  def shared_users
    @users ||= User.include_current_user(current_user, current_list)
  end

  helper_method :shared_users
end
