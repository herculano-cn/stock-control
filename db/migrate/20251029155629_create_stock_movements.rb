class CreateStockMovements < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_movements do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :movement_type, null: false
      t.decimal :quantity, precision: 10, scale: 2, null: false
      t.decimal :unit_cost, precision: 10, scale: 2
      t.text :reason
      t.string :reference_document
      t.datetime :movement_date, null: false

      t.timestamps
    end
    
    add_index :stock_movements, :movement_type
    add_index :stock_movements, :movement_date
    add_index :stock_movements, [:product_id, :movement_date]
  end
end
