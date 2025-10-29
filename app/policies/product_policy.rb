class ProductPolicy < ApplicationPolicy
  # All authenticated users can view products
  def index?
    user.present?
  end
  
  def show?
    user.present?
  end
  
  # All authenticated users can view low stock products
  def low_stock?
    user.present?
  end
  
  # All authenticated users can export products
  def export?
    user.present?
  end
  
  # Only managers and admins can create products
  def create?
    user.present? && (user.manager? || user.admin?)
  end
  
  def new?
    create?
  end
  
  # Only managers and admins can update products
  def update?
    user.present? && (user.manager? || user.admin?)
  end
  
  def edit?
    update?
  end
  
  # Only admins can destroy (deactivate) products
  def destroy?
    user.present? && user.admin?
  end
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end