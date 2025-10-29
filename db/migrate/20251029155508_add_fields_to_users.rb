class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :role, :integer, default: 2, null: false
    add_column :users, :active, :boolean, default: true, null: false
    add_column :users, :deleted_at, :datetime
    
    add_index :users, :role
    add_index :users, :deleted_at
  end
end
