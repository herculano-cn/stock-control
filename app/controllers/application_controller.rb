class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Pundit authorization
  include Pundit::Authorization
  
  # Devise authentication - require authentication for all actions
  before_action :authenticate_user!
  
  # Rescue from Pundit authorization errors
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  private
  
  # Handle authorization errors
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
