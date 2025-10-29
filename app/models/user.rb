class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Soft delete support
  acts_as_paranoid

  # Enums
  enum role: { admin: 0, manager: 1, operator: 2 }

  # Relationships
  has_many :stock_movements, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, length: { minimum: 3 }
  validates :role, presence: true
  validates :email, presence: true, uniqueness: true
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :by_role, ->(role) { where(role: role) }
end
