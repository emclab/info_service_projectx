Rails.application.routes.draw do

  mount InfoServiceProjectx::Engine => "/info_service_projectx"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Kustomerx::Engine => '/kustomerx'
  mount Searchx::Engine => '/search'
  mount StateMachineLogx::Engine => '/sm_log'
  mount BizWorkflowx::Engine => '/biz_wf'
  mount OnboardDatax::Engine => '/onboard'
  mount OnboardDataUploadx::Engine => '/onboard_upload'
  mount ProjectMiscDefinitionx::Engine => '/misc_definition'
  mount SwModuleInfox::Engine => '/engine'
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
