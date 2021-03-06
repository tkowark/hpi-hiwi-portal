HpiHiwiPortal::Application.routes.draw do

  prefix = HpiHiwiPortal::Application.config.relative_url_root || ''

  scope prefix do

    scope "(:locale)", locale: /en|de/ do

      root to: "home#index"

      namespace :admin do
        resource :configurable, except: [:index]
      end

      get 'admin/overview' => 'home#admin_overview'

      resources :job_offers do
        collection do
          get "archive"
          get "matching"
          get "export"
        end
        member do
          get "close"
          get "accept"
          get "decline"
          get "reopen"
          get "prolong"
          get "request_prolong"
        end
      end

      resources :employers do
        collection do
          get "home"
          get "export"
          post "export" => "employers#send_csv"
        end
        member do
          get "activate"
          get "extend_package"
          get "deactivate"
          post "invite_colleague"
        end
        resources :ratings
      end

      resources :alumni, only: [:new, :create, :index, :show] do
        collection do
          get 'remind_via_mail'
          get 'remind_all'
          post 'import' => 'alumni#create_from_csv'
          post 'mail_csv' => 'alumni#send_mail_from_csv'
        end
      end
      get 'alumni/:token/email' => 'alumni#register', as: 'alumni_email'
      post 'alumni/:token/link' => 'alumni#link', as: 'alumni_link'
      post 'alumni/:token/link_new' => 'alumni#link_new', as: 'alumni_link_new'
      post 'alumni/update_alumni_data' => 'alumni#update_alumni_data', as: 'update_alumni_data'

      post 'forgot_password' => 'users#forgot_password'

      resources :users, only: [:edit, :update] do
        patch 'update_password' => 'users#update_password', as: 'update_password'
      end

      resources :home, only: [:index, :imprint, :privacy]
      get 'home/imprint'
      get 'home/privacy'

      resources :sessions, only: [:create]
      get 'signin' => 'home#index', as: 'signin'
      delete 'signout' => 'sessions#destroy', as: 'signout'

      resources :studentsearch
      resources :faqs

      resources :staff, except: [:edit, :update, :new] do
        collection do
          get 'new/:token', to: 'staff#new', as: 'new'
        end
      end

      resources :students do
        member do
          patch 'activate'
          get 'activate'
        end
        collection do
          get 'export_alumni' => 'students#export_alumni'
          post 'export_alumni' => 'students#send_alumni_csv'
        end
      end

      resources :newsletter_orders, only: [:destroy, :create, :new, :show]

    end
  end
end
