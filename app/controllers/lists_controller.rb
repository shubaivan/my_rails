class ListsController < ApplicationController
  def index
    @user = current_user
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.user= current_user
    render(:new) unless @list.save
  end

  def list_params
    params.require(:list).permit(:title)
  end
end
