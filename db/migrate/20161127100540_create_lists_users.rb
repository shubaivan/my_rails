class CreateListsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :lists_users do |t|

      t.timestamps
    end
  end
end
