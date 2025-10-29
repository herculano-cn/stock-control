class CategoryPolicy < ApplicationPolicy
  # All authenticated users can view categories
  def index?
    user.present?
  end
  
  def show?
    user.present?
  end
  
  # Only managers and admins can create categories
  def create?
    user.present? && (user.manager? || user.admin?)
  end
  
  def new?
    create?
  end
  
  # Only managers and admins can update categories
  def update?
    user.present? && (user.manager? || user.admin?)
  end
  
  def edit?
    update?
  end
  
  # Only admins can destroy (deactivate) categories
  def destroy?
    user.present? && user.admin?
  end
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end