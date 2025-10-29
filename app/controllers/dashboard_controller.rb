class DashboardController < ApplicationController
  # Dashboard is accessible to all authenticated users
  def index
    # Authorize dashboard access
    authorize :dashboard, :index?
    
    # Metrics for dashboard
    @total_products = Product.active.count
    @low_stock_products = Product.active.where('current_stock <= minimum_stock').count
    @total_stock_value = calculate_total_stock_value
    @recent_movements = StockMovement.includes(:product, :user)
                                     .order(created_at: :desc)
                                     .limit(10)
    
    # Additional metrics
    @out_of_stock_products = Product.active.where(current_stock: 0).count
    @total_categories = Category.active.count
    @total_suppliers = Supplier.active.count
  end
  
  private
  
  def calculate_total_stock_value
    Product.active.sum('current_stock * selling_price')
  end
end