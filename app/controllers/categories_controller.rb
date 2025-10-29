class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :authorize_category, only: [:show, :edit, :update, :destroy]
  
  # GET /categories
  def index
    authorize Category
    @q = Category.ransack(params[:q])
    @categories = @q.result.order(name: :asc).page(params[:page])
  end
  
  # GET /categories/:id
  def show
    # Authorization handled by before_action
    @products = @category.products.active.page(params[:page])
  end
  
  # GET /categories/new
  def new
    @category = Category.new
    authorize @category
  end
  
  # POST /categories
  def create
    @category = Category.new(category_params)
    authorize @category
    
    if @category.save
      redirect_to @category, notice: 'Category was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  # GET /categories/:id/edit
  def edit
    # Authorization handled by before_action
  end
  
  # PATCH/PUT /categories/:id
  def update
    # Authorization handled by before_action
    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /categories/:id
  def destroy
    # Authorization handled by before_action
    # Soft delete - just deactivate
    if @category.update(active: false)
      redirect_to categories_url, notice: 'Category was successfully deactivated.'
    else
      redirect_to categories_url, alert: 'Failed to deactivate category.'
    end
  end
  
  private
  
  def set_category
    @category = Category.find(params[:id])
  end
  
  def authorize_category
    authorize @category
  end
  
  def category_params
    params.require(:category).permit(:name, :description, :active)
  end
end