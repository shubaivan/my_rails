class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.integer :priority, default: 1
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
