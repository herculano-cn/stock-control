class StockMovementsController < ApplicationController
  before_action :set_stock_movement, only: [:show]
  before_action :authorize_stock_movement, only: [:show]
  
  # GET /stock_movements
  def index
    authorize StockMovement
    @q = StockMovement.includes(:product, :user).ransack(params[:q])
    @stock_movements = @q.result.order(movement_date: :desc, created_at: :desc).page(params[:page])
  end
  
  # GET /stock_movements/report
  def report
    authorize StockMovement, :report?
    
    # Apply filters
    @q = StockMovement.includes(:product, :user).ransack(params[:q])
    @stock_movements = @q.result.order(movement_date: :desc, created_at: :desc)
    
    # Calculate totals by movement type
    @totals_by_type = @stock_movements.group(:movement_type).sum(:quantity)
    @value_by_type = @stock_movements.group(:movement_type).sum(:total_value)
    
    respond_to do |format|
      format.html
      format.csv do
        send_data generate_csv(@stock_movements),
                  filename: "stock-movements-report-#{Date.today}.csv",
                  type: 'text/csv'
      end
      format.pdf do
        # PDF export would be implemented with Prawn gem
        redirect_to report_stock_movements_path, notice: 'PDF export will be implemented with Prawn gem'
      end
    end
  end
  
  # GET /stock_movements/:id
  def show
    # Authorization handled by before_action
  end
  
  # GET /stock_movements/new
  def new
    @stock_movement = StockMovement.new
    authorize @stock_movement
    load_form_collections
  end
  
  # POST /stock_movements
  def create
    @stock_movement = StockMovement.new(stock_movement_params)
    @stock_movement.user = current_user
    authorize @stock_movement
    
    if @stock_movement.save
      redirect_to @stock_movement, notice: 'Stock movement was successfully created.'
    else
      load_form_collections
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_stock_movement
    @stock_movement = StockMovement.find(params[:id])
  end
  
  def authorize_stock_movement
    authorize @stock_movement
  end
  
  def load_form_collections
    @products = Product.active.order(name: :asc)
  end
  
  def stock_movement_params
    params.require(:stock_movement).permit(
      :product_id, :movement_type, :quantity, :unit_cost,
      :reason, :reference_document, :movement_date
    )
  end
  
  def generate_csv(stock_movements)
    require 'csv'
    
    CSV.generate(headers: true) do |csv|
      csv << ['Date', 'Product', 'Type', 'Quantity', 'Unit Cost', 'Total Value',
              'Reason', 'User', 'Reference']
      
      stock_movements.each do |movement|
        csv << [
          movement.movement_date,
          movement.product.name,
          movement.movement_type,
          movement.quantity,
          movement.unit_cost,
          movement.total_value,
          movement.reason,
          movement.user.name,
          movement.reference_document
        ]
      end
    end
  end
end