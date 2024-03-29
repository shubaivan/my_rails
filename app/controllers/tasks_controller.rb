class TasksController < ApplicationController
  # before_action :authorize
  before_action :normalize_params, only: :update
  before_action :check_current_user, only: [:index, :update, :create, :destroy, :edit]

  def index
    @task = Task.new
  end

  def create
    @task = for_current_list.tasks.build(task_params)
    render(:new) unless @task.save
  end

  def update
    @task = for_current_list.tasks.find(params[:id])
    @task.update(task_params)
  end

  def edit
    @task = for_current_list.tasks.find(params[:id])
  end

  def update_all
    for_current_list.tasks.update_all(done: params[:done].present?)
    # head :ok, content_type: 'text/html'
  end

  def destroy
    @task = for_current_list.tasks.find(params[:id])
    @task.destroy
  end

  def remove_completed
    for_current_list.tasks.where(done: true).delete_all
  end

  private

  def normalize_params
    params[:task] ||= { done: false }
  end

  def task_params
    params.fetch(:task).permit(:title, :done)
  end

  def tasks
    @tasks ||= for_current_list.tasks.filtered(params[:type]).order(id: :desc)
  end

  # Confirms a logged-in user.
  def check_current_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms a logged-in user.
  def for_current_list
    @list = List.find_by(id: params[:list_id])
  end

  helper_method :tasks, :for_current_list
end
