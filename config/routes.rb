Rails.application.routes.draw do
  devise_for :users

  resources :users do
    get :connect_guest_user
  end

  resources :tables

  resources :values, only: [] do
    get :signature
  end  

  resources :fields, only: %i[create edit update destroy] do
    post :update_row_order, on: :collection
  end

  # namespace :api, defaults: {format: :json}  do
  #   namespace :v1 do
  #     get 'timestamps', to: 'users#timestamps'
  #     post 'values/post_value'
  #     resources :users 
  #     resources :tables
  #     resources :fields
  #     resources :values
  #   end
  #   namespace :v2 do

  #   end
  # end

  controller :pages do
    get :a_propos, to: 'pages#a_propos'
  end

  get "show_attrs" => "tables#show_attrs" 
  get 'tables/:id/fill' => 'tables#fill', as: :fill
  get 'tables/:id/add_user', to:'tables#add_user', as: :add_user
  get 'tables/:id/partages', to:'tables#partages', as: :partages
  get 'tables/:id/partages_delete', to:'tables#partages_delete', as: :annuler_partage
  get 'tables/:id/export', to: 'tables#export', as: :export
  get 'tables/:id/logs', to: 'tables#logs', as: :logs
  get 'tables/:id/activity', to: 'tables#activity', as: :activity

  post 'tables/:id/fill' => 'tables#fill_do', as: :fill_do
  post '/export_do', to: 'tables#export_do'
  post '/add_user_do', to:'tables#add_user_do'

  get '/import', to: 'tables#import'
  post '/import_do', to: 'tables#import_do'

  delete 'tables/:id/delete_record' => 'tables#delete_record', as: :delete_record

  resources :blobs, only: [:new, :create]

  get 'tables/:id/details', to: 'tables#show_details', as: :details
  get 'tables/:id/related_tables', to: 'tables#related_tables', as: :related_tables

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'tables#index'
end
