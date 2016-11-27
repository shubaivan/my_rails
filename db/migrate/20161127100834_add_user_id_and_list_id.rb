class AddUserIdAndListId < ActiveRecord::Migration[5.0]
  def change
    add_column :lists_users, :user_id, :integer
    add_column :lists_users, :list_id, :integer
  end
end
