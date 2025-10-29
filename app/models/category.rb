class Category < ApplicationRecord
  # Soft delete support
  acts_as_paranoid

  # Relationships
  has_many :products, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true,
                   uniqueness: true,
                   length: { maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :ordered_by_name, -> { order(:name) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "description", "id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["products"]
  end

  # Instance methods
  def toggle_active!
    update(active: !active)
  end
end
