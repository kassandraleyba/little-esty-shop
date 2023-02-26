Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :invoices, only: [:show, :index]
    resources :merchants, only: [:index, :show, :new, :create, :edit, :update]
  end

  get '/merchants/:merchant_id/dashboards', to: 'merchants#dashboards'

  get 'merchants/:merchant_id/items', to: 'merchants#items'
  get 'merchants/:merchant_id/items/new', to: 'items#new'
  get 'merchants/:merchant_id/items/:item_id', to: 'items#show'
  post 'merchants/:merchant_id/items/:item_id', to: 'items#create'
  get 'merchants/:merchant_id/items/:item_id/edit', to: 'items#edit'
  patch 'merchants/:merchant_id/items/:item_id', to: 'items#update'


  post '/items', to: 'items#create'
  patch '/items/:item_id', to: 'items#status_update'
  
  
end
