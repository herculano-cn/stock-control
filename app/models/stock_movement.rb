class StockMovement < ApplicationRecord
  # Enums
  enum movement_type: {
    entry: 0,
    exit: 1,
    adjustment: 2,
    return: 3
  }

  # Relationships
  belongs_to :product
  belongs_to :user

  # Validations
  validates :product, presence: true
  validates :user, presence: true
  validates :movement_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_cost, numericality: { greater_than: 0 }, allow_nil: true
  validates :movement_date, presence: true
  validate :movement_date_not_in_future
  validate :sufficient_stock_for_exit

  # Callbacks
  after_create :update_product_stock

  # Scopes
  scope :by_product, ->(product_id) { where(product_id: product_id) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_type, ->(type) { where(movement_type: type) }
  scope :by_date_range, ->(start_date, end_date) { where(movement_date: start_date..end_date) }
  scope :recent, -> { order(movement_date: :desc, created_at: :desc) }
  # Note: 'entries' and 'exits' scopes are automatically created by the enum

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "movement_date", "movement_type", "product_id",
     "quantity", "reason", "reference_document", "unit_cost", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product", "user"]
  end

  # Instance methods
  def total_value
    return 0 if unit_cost.nil? || quantity.nil?
    (unit_cost * quantity).round(2)
  end

  private

  def movement_date_not_in_future
    if movement_date.present? && movement_date > Date.today
      errors.add(:movement_date, "cannot be in the future")
    end
  end

  def sufficient_stock_for_exit
    if exit? && product.present?
      if quantity > product.current_stock
        errors.add(:quantity, "exceeds available stock (#{product.current_stock})")
      end
    end
  end

  def update_product_stock
    return unless product.present?
    
    case movement_type.to_sym
    when :entry, :return
      product.increment!(:current_stock, quantity)
    when :exit
      product.decrement!(:current_stock, quantity)
    when :adjustment
      product.update!(current_stock: quantity)
    end
  end
end
