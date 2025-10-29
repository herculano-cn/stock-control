class SupplierPolicy < ApplicationPolicy
  # All authenticated users can view suppliers
  def index?
    user.present?
  end
  
  def show?
    user.present?
  end
  
  # Only managers and admins can create suppliers
  def create?
    user.present? && (user.manager? || user.admin?)
  end
  
  def new?
    create?
  end
  
  # Only managers and admins can update suppliers
  def update?
    user.present? && (user.manager? || user.admin?)
  end
  
  def edit?
    update?
  end
  
  # Only admins can destroy (deactivate) suppliers
  def destroy?
    user.present? && user.admin?
  end
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end