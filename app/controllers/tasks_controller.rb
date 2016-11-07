class TasksController < ApplicationController
  def index
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    render(:new) unless @task.save
  end

  def update
    @task = Task.find(params[:id])
    @task.update!(done: params[:done].present?)
  end

  private

  def task_params
    params.require(:task).permit(:title)
  end

  def tasks
    @tasks ||= Task.filtered(params[:type]).order(id: :desc)
  end
  helper_method :tasks
end
