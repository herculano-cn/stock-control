class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  before_action :authorize_supplier, only: [:show, :edit, :update, :destroy]
  
  # GET /suppliers
  def index
    authorize Supplier
    @q = Supplier.ransack(params[:q])
    @suppliers = @q.result.order(name: :asc).page(params[:page])
  end
  
  # GET /suppliers/:id
  def show
    # Authorization handled by before_action
    @products = @supplier.products.active.page(params[:page])
  end
  
  # GET /suppliers/new
  def new
    @supplier = Supplier.new
    authorize @supplier
  end
  
  # POST /suppliers
  def create
    @supplier = Supplier.new(supplier_params)
    authorize @supplier
    
    if @supplier.save
      redirect_to @supplier, notice: 'Supplier was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  # GET /suppliers/:id/edit
  def edit
    # Authorization handled by before_action
  end
  
  # PATCH/PUT /suppliers/:id
  def update
    # Authorization handled by before_action
    if @supplier.update(supplier_params)
      redirect_to @supplier, notice: 'Supplier was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /suppliers/:id
  def destroy
    # Authorization handled by before_action
    # Soft delete - just deactivate
    if @supplier.update(active: false)
      redirect_to suppliers_url, notice: 'Supplier was successfully deactivated.'
    else
      redirect_to suppliers_url, alert: 'Failed to deactivate supplier.'
    end
  end
  
  private
  
  def set_supplier
    @supplier = Supplier.find(params[:id])
  end
  
  def authorize_supplier
    authorize @supplier
  end
  
  def supplier_params
    params.require(:supplier).permit(:name, :cnpj, :email, :phone, :address, :active)
  end
end