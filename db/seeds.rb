# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Starting seeds..."

# Clear existing data (development only)
if Rails.env.development?
  puts "🧹 Cleaning existing data..."
  StockMovement.destroy_all
  Product.destroy_all
  Category.destroy_all
  Supplier.destroy_all
  User.destroy_all
end

# ========================================
# USERS
# ========================================
puts "\n👥 Creating users..."

admin = User.with_deleted.find_or_initialize_by(email: 'admin@stockcontrol.com')
admin.assign_attributes(
  name: 'Administrator',
  password: 'password123',
  password_confirmation: 'password123',
  role: :admin,
  active: true,
  deleted_at: nil
)
admin.save!
puts "✅ Admin created: #{admin.email} (password: password123)"

manager = User.with_deleted.find_or_initialize_by(email: 'manager@stockcontrol.com')
manager.assign_attributes(
  name: 'Manager Silva',
  password: 'password123',
  password_confirmation: 'password123',
  role: :manager,
  active: true,
  deleted_at: nil
)
manager.save!
puts "✅ Manager created: #{manager.email} (password: password123)"

operator = User.with_deleted.find_or_initialize_by(email: 'operator@stockcontrol.com')
operator.assign_attributes(
  name: 'Operator Santos',
  password: 'password123',
  password_confirmation: 'password123',
  role: :operator,
  active: true,
  deleted_at: nil
)
operator.save!
puts "✅ Operator created: #{operator.email} (password: password123)"

# ========================================
# CATEGORIES
# ========================================
puts "\n📁 Creating categories..."

categories = [
  { name: 'Electronics', description: 'Electronic products and technology' },
  { name: 'Food', description: 'Food products and beverages' },
  { name: 'Clothing', description: 'Clothes and accessories' },
  { name: 'Furniture', description: 'Furniture and decoration' },
  { name: 'Books', description: 'Books and educational materials' },
  { name: 'Tools', description: 'Tools and equipment' },
  { name: 'Toys', description: 'Toys and games' },
  { name: 'Sports', description: 'Sports articles' }
]

categories.each do |cat_data|
  category = Category.with_deleted.find_or_initialize_by(name: cat_data[:name])
  category.assign_attributes(
    description: cat_data[:description],
    active: true,
    deleted_at: nil
  )
  category.save!
  puts "✅ Category created: #{category.name}"
end

# ========================================
# SUPPLIERS
# ========================================
puts "\n🏢 Creating suppliers..."

suppliers = [
  {
    name: 'Tech Solutions Ltd',
    cnpj: '12345678000190',
    email: 'contact@techsolutions.com',
    phone: '11987654321',
    address: '1000 Paulista Ave - São Paulo, SP'
  },
  {
    name: 'Fresh Foods Inc',
    cnpj: '98765432000110',
    email: 'sales@freshfoods.com',
    phone: '21976543210',
    address: '500 Flowers St - Rio de Janeiro, RJ'
  },
  {
    name: 'Fashion & Style',
    cnpj: '11223344000155',
    email: 'commercial@fashionstyle.com',
    phone: '31965432109',
    address: '2000 Afonso Pena Ave - Belo Horizonte, MG'
  },
  {
    name: 'Design Furniture',
    cnpj: '55667788000199',
    email: 'service@designfurniture.com',
    phone: '41954321098',
    address: '300 XV November St - Curitiba, PR'
  },
  {
    name: 'National Distributor',
    cnpj: '99887766000144',
    email: 'sales@nationaldist.com',
    phone: '85943210987',
    address: '1500 Seaside Ave - Fortaleza, CE'
  }
]

suppliers.each do |sup_data|
  supplier = Supplier.with_deleted.find_or_initialize_by(cnpj: sup_data[:cnpj])
  supplier.assign_attributes(
    name: sup_data[:name],
    email: sup_data[:email],
    phone: sup_data[:phone],
    address: sup_data[:address],
    active: true,
    deleted_at: nil
  )
  supplier.save!
  puts "✅ Supplier created: #{supplier.name}"
end

# ========================================
# PRODUCTS
# ========================================
puts "\n📦 Creating products..."

# Find created categories and suppliers
electronics = Category.find_by(name: 'Electronics')
food = Category.find_by(name: 'Food')
clothing = Category.find_by(name: 'Clothing')
furniture = Category.find_by(name: 'Furniture')
books = Category.find_by(name: 'Books')

tech_solutions = Supplier.find_by(name: 'Tech Solutions Ltd')
fresh_foods = Supplier.find_by(name: 'Fresh Foods Inc')
fashion_style = Supplier.find_by(name: 'Fashion & Style')
design_furniture = Supplier.find_by(name: 'Design Furniture')
national_dist = Supplier.find_by(name: 'National Distributor')

products = [
  # Electronics
  {
    sku: 'ELEC-001',
    name: 'Dell Inspiron 15 Notebook',
    description: 'Notebook with Intel Core i5 processor, 8GB RAM, 256GB SSD',
    category: electronics,
    supplier: tech_solutions,
    selling_price: 3500.00,
    cost_price: 2800.00,
    current_stock: 15,
    minimum_stock: 5,
    maximum_stock: 30,
    unit_of_measure: :unit
  },
  {
    sku: 'ELEC-002',
    name: 'Logitech MX Master 3 Mouse',
    description: 'Wireless ergonomic mouse with high precision sensor',
    category: electronics,
    supplier: tech_solutions,
    selling_price: 450.00,
    cost_price: 320.00,
    current_stock: 25,
    minimum_stock: 10,
    maximum_stock: 50,
    unit_of_measure: :unit
  },
  {
    sku: 'ELEC-003',
    name: 'RGB Mechanical Keyboard',
    description: 'Mechanical keyboard with customizable RGB lighting',
    category: electronics,
    supplier: tech_solutions,
    selling_price: 380.00,
    cost_price: 250.00,
    current_stock: 3,
    minimum_stock: 8,
    maximum_stock: 40,
    unit_of_measure: :unit
  },
  # Food
  {
    sku: 'FOOD-001',
    name: 'Brown Rice 1kg',
    description: 'Type 1 brown rice, rich in fiber',
    category: food,
    supplier: fresh_foods,
    selling_price: 8.50,
    cost_price: 5.20,
    current_stock: 100,
    minimum_stock: 50,
    maximum_stock: 200,
    unit_of_measure: :kg
  },
  {
    sku: 'FOOD-002',
    name: 'Black Beans 1kg',
    description: 'Type 1 black beans, selected',
    category: food,
    supplier: fresh_foods,
    selling_price: 7.80,
    cost_price: 4.50,
    current_stock: 80,
    minimum_stock: 40,
    maximum_stock: 150,
    unit_of_measure: :kg
  },
  {
    sku: 'FOOD-003',
    name: 'Soybean Oil 900ml',
    description: 'Refined soybean oil',
    category: food,
    supplier: fresh_foods,
    selling_price: 6.90,
    cost_price: 4.20,
    current_stock: 2,
    minimum_stock: 30,
    maximum_stock: 100,
    unit_of_measure: :liter
  },
  # Clothing
  {
    sku: 'CLOT-001',
    name: 'Basic Cotton T-Shirt',
    description: '100% cotton t-shirt, various colors',
    category: clothing,
    supplier: fashion_style,
    selling_price: 45.00,
    cost_price: 25.00,
    current_stock: 50,
    minimum_stock: 20,
    maximum_stock: 100,
    unit_of_measure: :unit
  },
  {
    sku: 'CLOT-002',
    name: 'Men\'s Jeans',
    description: 'Traditional jeans, various sizes',
    category: clothing,
    supplier: fashion_style,
    selling_price: 120.00,
    cost_price: 75.00,
    current_stock: 30,
    minimum_stock: 15,
    maximum_stock: 60,
    unit_of_measure: :unit
  },
  # Furniture
  {
    sku: 'FURN-001',
    name: 'Ergonomic Office Chair',
    description: 'Chair with height adjustment and lumbar support',
    category: furniture,
    supplier: design_furniture,
    selling_price: 650.00,
    cost_price: 420.00,
    current_stock: 12,
    minimum_stock: 5,
    maximum_stock: 25,
    unit_of_measure: :unit
  },
  {
    sku: 'FURN-002',
    name: 'Office Desk 120x60cm',
    description: 'MDF desk with wood finish',
    category: furniture,
    supplier: design_furniture,
    selling_price: 450.00,
    cost_price: 280.00,
    current_stock: 8,
    minimum_stock: 5,
    maximum_stock: 20,
    unit_of_measure: :unit
  },
  # Books
  {
    sku: 'BOOK-001',
    name: 'Clean Code - Robert Martin',
    description: 'Book about programming best practices',
    category: books,
    supplier: national_dist,
    selling_price: 85.00,
    cost_price: 55.00,
    current_stock: 20,
    minimum_stock: 10,
    maximum_stock: 40,
    unit_of_measure: :unit
  },
  {
    sku: 'BOOK-002',
    name: 'Design Patterns - Gang of Four',
    description: 'Classic book about design patterns',
    category: books,
    supplier: national_dist,
    selling_price: 95.00,
    cost_price: 62.00,
    current_stock: 1,
    minimum_stock: 8,
    maximum_stock: 35,
    unit_of_measure: :unit
  }
]

products.each do |prod_data|
  product = Product.with_deleted.find_or_initialize_by(sku: prod_data[:sku])
  product.assign_attributes(
    name: prod_data[:name],
    description: prod_data[:description],
    category: prod_data[:category],
    supplier: prod_data[:supplier],
    selling_price: prod_data[:selling_price],
    cost_price: prod_data[:cost_price],
    current_stock: prod_data[:current_stock],
    minimum_stock: prod_data[:minimum_stock],
    maximum_stock: prod_data[:maximum_stock],
    unit_of_measure: prod_data[:unit_of_measure],
    active: true,
    deleted_at: nil
  )
  product.save!
  
  stock_status = if product.current_stock <= product.minimum_stock
    "⚠️  LOW"
  elsif product.current_stock == 0
    "❌ OUT OF STOCK"
  else
    "✅ OK"
  end
  
  puts "✅ Product created: #{product.name} - Stock: #{product.current_stock} #{stock_status}"
end

# ========================================
# STOCK MOVEMENTS (Examples)
# ========================================
puts "\n📊 Creating sample stock movements..."

# Create some sample movements
sample_products = Product.limit(5)

sample_products.each_with_index do |product, index|
  # Entry
  StockMovement.create!(
    product: product,
    user: admin,
    movement_type: :entry,
    quantity: 10,
    unit_cost: product.cost_price,
    reason: 'Initial purchase',
    movement_date: 30.days.ago,
    reference_document: "INV-#{1000 + index}"
  )
  
  # Exit
  StockMovement.create!(
    product: product,
    user: operator,
    movement_type: :exit,
    quantity: 5,
    unit_cost: product.selling_price,
    reason: 'Sale',
    movement_date: 15.days.ago,
    reference_document: "SALE-#{2000 + index}"
  )
end

puts "✅ Sample stock movements created"

# ========================================
# SUMMARY
# ========================================
puts "\n" + "="*50
puts "✅ SEEDS COMPLETED SUCCESSFULLY!"
puts "="*50
puts "\n📊 Summary:"
puts "  👥 Users: #{User.count}"
puts "  📁 Categories: #{Category.count}"
puts "  🏢 Suppliers: #{Supplier.count}"
puts "  📦 Products: #{Product.count}"
puts "  📊 Stock Movements: #{StockMovement.count}"
puts "\n🔐 Login credentials:"
puts "  Admin:    admin@stockcontrol.com / password123"
puts "  Manager:  manager@stockcontrol.com / password123"
puts "  Operator: operator@stockcontrol.com / password123"
puts "\n⚠️  Products with low stock: #{Product.where('current_stock <= minimum_stock').count}"
puts "="*50
