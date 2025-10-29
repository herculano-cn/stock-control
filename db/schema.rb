# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_10_29_155629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "active", default: true, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_categories_on_active"
    t.index ["deleted_at"], name: "index_categories_on_deleted_at"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "sku", null: false
    t.string "name", null: false
    t.text "description"
    t.bigint "category_id", null: false
    t.bigint "supplier_id", null: false
    t.integer "unit_of_measure", default: 0, null: false
    t.decimal "cost_price", precision: 10, scale: 2
    t.decimal "selling_price", precision: 10, scale: 2, null: false
    t.decimal "current_stock", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "minimum_stock", precision: 10, scale: 2, default: "0.0"
    t.decimal "maximum_stock", precision: 10, scale: 2
    t.boolean "active", default: true, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_products_on_active"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["current_stock"], name: "index_products_on_current_stock"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "stock_movements", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.integer "movement_type", null: false
    t.decimal "quantity", precision: 10, scale: 2, null: false
    t.decimal "unit_cost", precision: 10, scale: 2
    t.text "reason"
    t.string "reference_document"
    t.datetime "movement_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movement_date"], name: "index_stock_movements_on_movement_date"
    t.index ["movement_type"], name: "index_stock_movements_on_movement_type"
    t.index ["product_id", "movement_date"], name: "index_stock_movements_on_product_id_and_movement_date"
    t.index ["product_id"], name: "index_stock_movements_on_product_id"
    t.index ["user_id"], name: "index_stock_movements_on_user_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name", null: false
    t.string "cnpj", null: false
    t.string "email"
    t.string "phone"
    t.text "address"
    t.string "contact_person"
    t.boolean "active", default: true, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_suppliers_on_active"
    t.index ["cnpj"], name: "index_suppliers_on_cnpj", unique: true
    t.index ["deleted_at"], name: "index_suppliers_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "role", default: 2, null: false
    t.boolean "active", default: true, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "products", "categories"
  add_foreign_key "products", "suppliers"
  add_foreign_key "stock_movements", "products"
  add_foreign_key "stock_movements", "users"
end
