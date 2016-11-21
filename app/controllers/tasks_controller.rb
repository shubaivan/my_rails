class TasksController < ApplicationController
  before_action :authorize
  before_action :normalize_params, only: :update

  def index
    @task = Task.new
  end

  def create
    @task = current_list.tasks.build(task_params)
    render(:new) unless @task.save
  end

  def update
    @task = current_list.tasks.find(params[:id])
    @task.update(task_params)
  end

  def edit
    @task = current_list.tasks.find(params[:id])
  end

  def update_all
    current_list.tasks.update_all(done: params[:done].present?)
    head :ok, content_type: 'text/html'
  end

  def destroy
    @task = current_list.tasks.find(params[:id])
    @task.destroy
  end

  def remove_completed
    current_list.tasks.where(done: true).delete_all
  end

  private

  def normalize_params
    params[:task] ||= { done: false }
  end

  def task_params
    params.fetch(:task).permit(:title, :done)
  end

  def tasks
    @tasks ||= current_list.tasks.filtered(params[:type]).order(id: :desc)
  end

  helper_method :tasks
end
