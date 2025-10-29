# Stock Control System

A comprehensive stock control system built with Ruby on Rails 7.1+, featuring role-based access control, real-time inventory tracking, and detailed reporting capabilities.

## Features

### Core Functionality
- **Product Management**: Complete CRUD operations for products with SKU tracking
- **Category Management**: Organize products into hierarchical categories
- **Supplier Management**: Track supplier information and relationships
- **Stock Movements**: Record and track all inventory movements (entries/exits)
- **Dashboard**: Real-time metrics and recent activity overview
- **Search & Filter**: Advanced search using Ransack across all entities
- **Pagination**: Efficient data browsing with Kaminari
- **Soft Deletes**: Safe deletion with recovery capability using acts_as_paranoid

### Security & Authorization
- **Authentication**: Secure user authentication with Devise
- **Role-Based Access Control**: Three user roles with distinct permissions
  - **Admin**: Full system access including user management and deletions
  - **Manager**: Can create, read, and update all entities (no deletions)
  - **Operator**: Can view all data and create stock movements only

### User Interface
- **Responsive Design**: Mobile-first design using Tailwind CSS
- **Modern UI**: Clean, professional interface with intuitive navigation
- **Real-time Feedback**: Flash messages for user actions
- **Mobile Menu**: Collapsible navigation for mobile devices

## Technology Stack

- **Ruby**: 3.2+
- **Rails**: 7.1+
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Authorization**: Pundit
- **Pagination**: Kaminari
- **Search**: Ransack
- **Styling**: Tailwind CSS
- **Soft Deletes**: acts_as_paranoid

## Installation

### Prerequisites
- Ruby 3.2 or higher
- PostgreSQL 12 or higher
- Node.js 18 or higher
- Yarn or npm

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd stock-control-system
   ```

2. **Install dependencies**
   ```bash
   bundle install
   yarn install
   ```

3. **Configure database**
   ```bash
   # Edit config/database.yml with your PostgreSQL credentials
   cp config/database.yml.example config/database.yml
   ```

4. **Create and setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

5. **Compile assets**
   ```bash
   bin/rails tailwindcss:build
   ```

6. **Start the server**
   ```bash
   rails server
   ```

7. **Access the application**
   - Open your browser and navigate to `http://localhost:3000`
   - Use the seeded credentials to login (see Seeds section below)

## Database Schema

### Users
- `email`: string (unique, required)
- `name`: string (required)
- `role`: enum (admin, manager, operator)
- `active`: boolean
- Devise fields (encrypted_password, reset_password_token, etc.)

### Categories
- `name`: string (required, unique)
- `description`: text
- `active`: boolean
- Soft delete support

### Suppliers
- `name`: string (required, unique)
- `contact_name`: string
- `email`: string
- `phone`: string
- `address`: text
- `active`: boolean
- Soft delete support

### Products
- `sku`: string (required, unique)
- `name`: string (required)
- `description`: text
- `category_id`: foreign key
- `supplier_id`: foreign key
- `unit_of_measure`: string
- `cost_price`: decimal (10,2)
- `selling_price`: decimal (10,2)
- `current_stock`: decimal (10,2)
- `minimum_stock`: decimal (10,2)
- `maximum_stock`: decimal (10,2)
- `active`: boolean
- Soft delete support

### Stock Movements
- `product_id`: foreign key (required)
- `user_id`: foreign key (required)
- `movement_type`: enum (entry, exit)
- `quantity`: decimal (10,2, required, positive)
- `unit_cost`: decimal (10,2)
- `reason`: text
- `reference_document`: string
- `movement_date`: date (required)
- Immutable after creation (no updates/deletes)

## Seeds

The seed file creates sample data for testing:

### Default Users
```ruby
# Admin User
Email: admin@example.com
Password: password123
Role: Admin

# Manager User
Email: manager@example.com
Password: password123
Role: Manager

# Operator User
Email: operator@example.com
Password: password123
Role: Operator
```

### Sample Data
- 5 Categories (Electronics, Furniture, Office Supplies, Clothing, Food & Beverages)
- 3 Suppliers
- 10 Products with varying stock levels
- 20 Stock movements (entries and exits)

## Authorization Matrix

| Action | Admin | Manager | Operator |
|--------|-------|---------|----------|
| **Dashboard** |
| View Dashboard | ✓ | ✓ | ✓ |
| **Categories** |
| View Categories | ✓ | ✓ | ✓ |
| Create Category | ✓ | ✓ | ✗ |
| Update Category | ✓ | ✓ | ✗ |
| Delete Category | ✓ | ✗ | ✗ |
| **Suppliers** |
| View Suppliers | ✓ | ✓ | ✓ |
| Create Supplier | ✓ | ✓ | ✗ |
| Update Supplier | ✓ | ✓ | ✗ |
| Delete Supplier | ✓ | ✗ | ✗ |
| **Products** |
| View Products | ✓ | ✓ | ✓ |
| Create Product | ✓ | ✓ | ✗ |
| Update Product | ✓ | ✓ | ✗ |
| Delete Product | ✓ | ✗ | ✗ |
| Export Products | ✓ | ✓ | ✓ |
| View Low Stock | ✓ | ✓ | ✓ |
| **Stock Movements** |
| View Movements | ✓ | ✓ | ✓ |
| Create Movement | ✓ | ✓ | ✓ |
| View Reports | ✓ | ✓ | ✓ |
| Update Movement | ✗ | ✗ | ✗ |
| Delete Movement | ✗ | ✗ | ✗ |

## Routes

### Authentication
- `GET /users/sign_in` - Login page
- `POST /users/sign_in` - Login action
- `DELETE /users/sign_out` - Logout action

### Dashboard
- `GET /dashboard` - Main dashboard

### Categories
- `GET /categories` - List all categories
- `GET /categories/:id` - Show category details
- `GET /categories/new` - New category form
- `POST /categories` - Create category
- `GET /categories/:id/edit` - Edit category form
- `PATCH /categories/:id` - Update category
- `DELETE /categories/:id` - Delete category

### Suppliers
- `GET /suppliers` - List all suppliers
- `GET /suppliers/:id` - Show supplier details
- `GET /suppliers/new` - New supplier form
- `POST /suppliers` - Create supplier
- `GET /suppliers/:id/edit` - Edit supplier form
- `PATCH /suppliers/:id` - Update supplier
- `DELETE /suppliers/:id` - Delete supplier

### Products
- `GET /products` - List all products
- `GET /products/:id` - Show product details
- `GET /products/new` - New product form
- `POST /products` - Create product
- `GET /products/:id/edit` - Edit product form
- `PATCH /products/:id` - Update product
- `DELETE /products/:id` - Delete product
- `GET /products/low_stock` - Products below minimum stock
- `GET /products/export` - Export products to CSV

### Stock Movements
- `GET /stock_movements` - List all movements
- `GET /stock_movements/:id` - Show movement details
- `GET /stock_movements/new` - New movement form
- `POST /stock_movements` - Create movement
- `GET /stock_movements/report` - Movement reports

## Key Features Explained

### Stock Movement Logic
- **Entry Movements**: Increase product stock by quantity
- **Exit Movements**: Decrease product stock by quantity
- **Validation**: Prevents negative stock on exits
- **Immutability**: Movements cannot be edited or deleted after creation
- **Audit Trail**: All movements are permanently recorded with user and timestamp

### Search Functionality
All list pages support search using Ransack:
- **Products**: Search by SKU, name, description, category name, supplier name
- **Categories**: Search by name, description
- **Suppliers**: Search by name, contact name, email, phone
- **Stock Movements**: Search by product name, movement type, reason

### Low Stock Alert
Products with `current_stock <= minimum_stock` are flagged as low stock and can be viewed in a dedicated page.

### Dashboard Metrics
- Total Products count
- Low Stock Products count
- Total Categories count
- Total Suppliers count
- Recent Stock Movements (last 10)

## Development

### Running Tests
```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/product_test.rb

# Run with coverage
COVERAGE=true rails test
```

### Code Quality
```bash
# Run Rubocop
rubocop

# Auto-fix issues
rubocop -a
```

### Database Console
```bash
# Open Rails console
rails console

# Open database console
rails dbconsole
```

## Deployment

### Heroku Deployment
```bash
# Create Heroku app
heroku create your-app-name

# Add PostgreSQL addon
heroku addons:create heroku-postgresql:mini

# Deploy
git push heroku main

# Run migrations
heroku run rails db:migrate

# Seed database
heroku run rails db:seed
```

### Environment Variables
Required environment variables for production:
- `DATABASE_URL`: PostgreSQL connection string
- `SECRET_KEY_BASE`: Rails secret key
- `RAILS_ENV`: Set to 'production'

## Troubleshooting

### Common Issues

**Issue**: Database connection error
```bash
# Solution: Check PostgreSQL is running
sudo service postgresql status
# Or on macOS
brew services list
```

**Issue**: Assets not loading
```bash
# Solution: Recompile assets
bin/rails assets:precompile
bin/rails tailwindcss:build
```

**Issue**: Permission denied errors
```bash
# Solution: Check user roles and policies
rails console
> user = User.find_by(email: 'your@email.com')
> user.role
> policy = ProductPolicy.new(user, Product.first)
> policy.create?
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@example.com or open an issue in the repository.

## Acknowledgments

- Rails community for excellent documentation
- Devise team for authentication solution
- Pundit team for authorization framework
- Tailwind CSS team for the styling framework
