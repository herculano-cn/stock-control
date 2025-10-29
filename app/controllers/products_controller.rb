class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_product, only: [:show, :edit, :update, :destroy]
  
  # GET /products
  def index
    authorize Product
    @q = Product.includes(:category, :supplier).ransack(params[:q])
    @products = @q.result.order(name: :asc).page(params[:page])
  end
  
  # GET /products/low_stock
  def low_stock
    authorize Product, :low_stock?
    @q = Product.includes(:category, :supplier)
                .where('current_stock <= minimum_stock')
                .ransack(params[:q])
    @products = @q.result.order(current_stock: :asc).page(params[:page])
    render :index
  end
  
  # GET /products/export
  def export
    authorize Product, :export?
    @products = Product.includes(:category, :supplier).active.order(name: :asc)
    
    respond_to do |format|
      format.csv do
        send_data generate_csv(@products), 
                  filename: "products-#{Date.today}.csv",
                  type: 'text/csv'
      end
      format.pdf do
        # PDF export would be implemented with Prawn gem
        # For now, just redirect with a notice
        redirect_to products_path, notice: 'PDF export will be implemented with Prawn gem'
      end
    end
  end
  
  # GET /products/:id
  def show
    # Authorization handled by before_action
    @stock_movements = @product.stock_movements
                               .includes(:user)
                               .order(movement_date: :desc, created_at: :desc)
                               .page(params[:page])
  end
  
  # GET /products/new
  def new
    @product = Product.new
    authorize @product
    load_form_collections
  end
  
  # POST /products
  def create
    @product = Product.new(product_params)
    authorize @product
    
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      load_form_collections
      render :new, status: :unprocessable_entity
    end
  end
  
  # GET /products/:id/edit
  def edit
    # Authorization handled by before_action
    load_form_collections
  end
  
  # PATCH/PUT /products/:id
  def update
    # Authorization handled by before_action
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      load_form_collections
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /products/:id
  def destroy
    # Authorization handled by before_action
    # Soft delete - just deactivate
    if @product.update(active: false)
      redirect_to products_url, notice: 'Product was successfully deactivated.'
    else
      redirect_to products_url, alert: 'Failed to deactivate product.'
    end
  end
  
  private
  
  def set_product
    @product = Product.find(params[:id])
  end
  
  def authorize_product
    authorize @product
  end
  
  def load_form_collections
    @categories = Category.active.order(name: :asc)
    @suppliers = Supplier.active.order(name: :asc)
  end
  
  def product_params
    params.require(:product).permit(
      :sku, :name, :description, :category_id, :supplier_id,
      :selling_price, :cost_price, :current_stock, :minimum_stock,
      :maximum_stock, :unit_of_measure, :active
    )
  end
  
  def generate_csv(products)
    require 'csv'
    
    CSV.generate(headers: true) do |csv|
      csv << ['SKU', 'Name', 'Category', 'Supplier', 'Selling Price', 'Cost Price',
              'Current Stock', 'Minimum Stock', 'Unit of Measure', 'Active']
      
      products.each do |product|
        csv << [
          product.sku,
          product.name,
          product.category.name,
          product.supplier.name,
          product.selling_price,
          product.cost_price,
          product.current_stock,
          product.minimum_stock,
          product.unit_of_measure,
          product.active
        ]
      end
    end
  end
end