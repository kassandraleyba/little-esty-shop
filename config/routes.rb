Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :invoices, only: [:show, :index, :update]
    resources :merchants, only: [:index, :show, :new, :create, :edit, :update]
  end


  resources :merchants, only: [:show] do
    get '/dashboard', to: 'merchants#dashboard'
    resources :items, only: [:index, :show, :new, :create, :edit, :update]
    resources :invoices 
    resources :bulk_discounts, only: [:index, :new, :create]
  end
  resources :invoice_items, only: [:update]
  resources :items, only: [:create]
  patch '/items/:item_id', to: 'items#status_update' #This needs to be fixed--there should not be more than one update path

end
