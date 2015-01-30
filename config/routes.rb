InfoServiceProjectx::Engine.routes.draw do
  resources :projects do
    collection do
      get :index_for_customer
      get :engine_for_config_check
      get :list_config_argument
      get :engine_for_access_check
      get :list_user_access
    end
  end
    
  root :to => 'projects#index'
end
