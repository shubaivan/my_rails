class ChangeTasks < ActiveRecord::Migration[5.0]
  def change
    remove_reference :tasks, :user
    add_reference :tasks, :list
  end
end
