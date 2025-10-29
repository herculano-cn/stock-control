class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :sku, null: false
      t.string :name, null: false
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.references :supplier, null: false, foreign_key: true
      t.integer :unit_of_measure, default: 0, null: false
      t.decimal :cost_price, precision: 10, scale: 2
      t.decimal :selling_price, precision: 10, scale: 2, null: false
      t.decimal :current_stock, precision: 10, scale: 2, default: 0, null: false
      t.decimal :minimum_stock, precision: 10, scale: 2, default: 0
      t.decimal :maximum_stock, precision: 10, scale: 2
      t.boolean :active, default: true, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    
    add_index :products, :sku, unique: true
    add_index :products, :active
    add_index :products, :current_stock
    add_index :products, :deleted_at
  end
end
