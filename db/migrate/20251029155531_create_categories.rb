class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: true, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    
    add_index :categories, :name, unique: true
    add_index :categories, :active
    add_index :categories, :deleted_at
  end
end
