class Supplier < ApplicationRecord
  # Soft delete support
  acts_as_paranoid

  # Relationships
  has_many :products, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, length: { minimum: 3 }
  validates :cnpj, presence: true,
                   uniqueness: true,
                   format: { with: /\A\d{14}\z/, message: "must be 14 digits" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :phone, format: { with: /\A\d{10,11}\z/ }, allow_blank: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :ordered_by_name, -> { order(:name) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["active", "address", "cnpj", "created_at", "email", "id", "name", "phone", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["products"]
  end

  # Instance methods
  def toggle_active!
    update(active: !active)
  end

  # Format CNPJ for display (XX.XXX.XXX/XXXX-XX)
  def formatted_cnpj
    return nil unless cnpj.present?
    cnpj.gsub(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '\1.\2.\3/\4-\5')
  end
end
