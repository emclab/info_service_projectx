InfoServiceProjectx::Engine.routes.draw do
  resources :projects do
    collection do
      get :index_for_customer
    end
  end
    
  root :to => 'projects#index'
end
