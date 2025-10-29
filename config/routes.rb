Rails.application.routes.draw do
  # Devise authentication
  devise_for :users
  
  # Root routes - authenticated users go to dashboard, others to login
  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end
  
  root 'devise/sessions#new'
  
  # Dashboard
  get 'dashboard', to: 'dashboard#index', as: :dashboard
  
  # Categories resource
  resources :categories
  
  # Suppliers resource
  resources :suppliers
  
  # Products resource with collection actions
  resources :products do
    collection do
      get :low_stock
      get :export
    end
  end
  
  # Stock Movements resource (limited actions - no edit/update/destroy)
  resources :stock_movements, only: [:index, :show, :new, :create] do
    collection do
      get :report
    end
  end
  
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
  
  # PWA files
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
