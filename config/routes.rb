Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  scope "(:locale)", locale: /en|fr/ do
    devise_scope :user do
      authenticated :user do
        root 'tables#index', as: :authenticated_root
      end
      
      unauthenticated do
        root 'devise/sessions#new', as: :unauthenticated_root
      end
    end
  
    root 'devise/sessions#new'
    
    resources :tables do
      # collection do
      #   get :securite
      # end
      member do
        get :icalendar
      end
    end
    resources :values
    resources :blobs, only: [:new, :create]

    resources :users, except: %i[show] do
      collection do
        get :profil
      end
      get :connect_guest_user
    end
    
    resources :fields, only: %i[create edit update destroy] do
      post :update_row_order, on: :collection
    end
    
    controller :pages do
      get :a_propos, to: 'pages#a_propos'
      get :graphs, to: 'pages#graphs'
      get :assistant, to: "pages#assistant"
      get :mentions_legales, to: "pages#mentions_legales"
      get :dashboard, to: 'pages#dashboard'
    end
    
    resources :filters do
      member do
        get :query
      end
    end

    resources :notifications, except: %i[show]
    resources :mail_logs, only: %i[index show]
    resources :organisations, only: %i[show edit update]

    namespace :admin do
      get :stats
      get :create_new_user
      post :create_new_user_do
      get :new_team
      post :create_team
    end
    
    get 'show_attrs', to: 'tables#show_attrs' 
    get 'tables/:id/fill', to: 'tables#fill', as: :fill
    # get 'tables/:id/partages', to:'tables#partages', as: :partages
    # get 'tables/:id/partages_delete', to:'tables#partages_delete', as: :annuler_partage
    get 'tables/:id/logs', to: 'tables#logs', as: :logs
    get 'tables/:id/activity', to: 'tables#activity', as: :activity
    get 'tables/:id/details', to: 'tables#show_details', as: :details
    get 'tables/:id/related_tables', to: 'tables#related_tables', as: :related_tables
    get '/import', to: 'tables#import'

    post 'tables/:id/fill', to: 'tables#fill_do', as: :fill_do
    # post '/add_user_do', to:'tables#add_user_do'
    post '/import_do', to: 'tables#import_do'

    delete 'tables/:id/delete_record' => 'tables#delete_record', as: :delete_record
    

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

    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".
  end
end
