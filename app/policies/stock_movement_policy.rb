class StockMovementPolicy < ApplicationPolicy
  # All authenticated users can view stock movements
  def index?
    user.present?
  end
  
  def show?
    user.present?
  end
  
  # All authenticated users can view reports
  def report?
    user.present?
  end
  
  # Operators, managers, and admins can create stock movements
  def create?
    user.present? && (user.operator? || user.manager? || user.admin?)
  end
  
  def new?
    create?
  end
  
  # Stock movements are immutable - no updates allowed
  def update?
    false
  end
  
  def edit?
    false
  end
  
  # Stock movements are immutable - no deletion allowed
  # (In the future, only admins could delete if needed, but for now it's disabled)
  def destroy?
    false
  end
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end