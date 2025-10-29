class Product < ApplicationRecord
  # Soft delete support
  acts_as_paranoid

  # Enums
  enum unit_of_measure: {
    unit: 0,
    kg: 1,
    liter: 2,
    meter: 3,
    box: 4,
    package: 5
  }

  # Relationships
  belongs_to :category
  belongs_to :supplier
  has_many :stock_movements, dependent: :restrict_with_error

  # Validations
  validates :sku, presence: true,
                  uniqueness: true,
                  format: { with: /\A[A-Z0-9\-]+\z/, message: "must be alphanumeric with hyphens" }
  validates :name, presence: true, length: { minimum: 3, maximum: 200 }
  validates :selling_price, presence: true, numericality: { greater_than: 0 }
  validates :cost_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :current_stock, numericality: { greater_than_or_equal_to: 0 }
  validates :minimum_stock, numericality: { greater_than_or_equal_to: 0 }
  validates :maximum_stock, numericality: { greater_than: :minimum_stock }, allow_nil: true
  validates :category, presence: true
  validates :supplier, presence: true
  validate :selling_price_greater_than_cost_price

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :low_stock, -> { where('current_stock <= minimum_stock') }
  scope :out_of_stock, -> { where(current_stock: 0) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :by_supplier, ->(supplier_id) { where(supplier_id: supplier_id) }
  scope :search, ->(term) { where('name ILIKE ? OR sku ILIKE ?', "%#{term}%", "%#{term}%") }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["active", "category_id", "cost_price", "created_at", "current_stock",
     "description", "id", "maximum_stock", "minimum_stock", "name",
     "selling_price", "sku", "supplier_id", "unit_of_measure", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "supplier", "stock_movements"]
  end

  # Instance methods
  def low_stock?
    current_stock <= minimum_stock
  end

  def out_of_stock?
    current_stock.zero?
  end

  def profit_margin
    return 0 if cost_price.nil? || cost_price.zero?
    ((selling_price - cost_price) / cost_price * 100).round(2)
  end

  def update_stock(quantity, movement_type)
    case movement_type.to_sym
    when :entry, :return
      increment!(:current_stock, quantity)
    when :exit
      decrement!(:current_stock, quantity)
    when :adjustment
      update!(current_stock: quantity)
    end
  end

  def toggle_active!
    update(active: !active)
  end

  private

  def selling_price_greater_than_cost_price
    if cost_price.present? && selling_price.present? && selling_price <= cost_price
      errors.add(:selling_price, "must be greater than cost price")
    end
  end
end
