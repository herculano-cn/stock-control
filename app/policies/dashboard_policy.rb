class DashboardPolicy < ApplicationPolicy
  # Dashboard is accessible to all authenticated users
  def index?
    user.present?
  end
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end