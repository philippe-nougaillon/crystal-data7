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
      member do
        get :show_attrs

        get :fill
        post :fill_do

        get :import
        post :import_do

        get :logs
        get :activity
        get :details
        get :icalendar
        get :related
        
      end
      collection do
        get :import
        post :import_do
        # get :securite
      end
    end

    resources :users, except: %i[show] do
      collection do
        get :profil
      end
      get :connect_guest_user
    end
    
    resources :fields, only: %i[create edit update destroy] do
      post :update_row_order, on: :collection
    end
        
    resources :filters do
      member do
        get :query
      end
    end

    resources :graphs do
      get :update_filters, on: :collection
    end

    resources :notifications, except: %i[show]
    resources :mail_logs, only: %i[index show]
    resources :organisations, only: %i[show edit update]
    resources :teams, except: %i[index show]
    resources :values
    resources :blobs, only: [:new, :create]

    controller :pages do
      get :a_propos, to: 'pages#a_propos'
      get :assistant, to: "pages#assistant"
      get :dashboard, to: 'pages#dashboard'
      get :mentions_legales, to: "pages#mentions_legales"
    end

    namespace :admin do
      get :stats
      get :assistant_logs
      get :create_new_user
      post :create_new_user_do
    end
    
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
