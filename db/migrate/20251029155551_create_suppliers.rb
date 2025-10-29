class CreateSuppliers < ActiveRecord::Migration[7.2]
  def change
    create_table :suppliers do |t|
      t.string :name, null: false
      t.string :cnpj, null: false
      t.string :email
      t.string :phone
      t.text :address
      t.string :contact_person
      t.boolean :active, default: true, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    
    add_index :suppliers, :cnpj, unique: true
    add_index :suppliers, :active
    add_index :suppliers, :deleted_at
  end
end
