class TasksController < ApplicationController
  before_action :normalize_params, only: :update
  before_action :check_current_user, only: [:index, :update, :create, :destroy, :edit]

  def index
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    render(:new) unless @task.save
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
  end

  def destroy
    Task.delete(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update_all
    Task.update_all(done: params[:done].present?)
  end

  private

  def normalize_params
    params[:task] ||= { done: false }
  end

  def task_params
    params.fetch(:task).permit(:title, :done)
  end

  def tasks
    @tasks ||= Task.filtered(params[:type]).order(id: :desc)
  end

  def check_current_user
    check = current_user.present?
    if !check
       redirect_to login_path
    end
  end

  helper_method :tasks
end
