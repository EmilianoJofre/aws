Rails.application.routes.draw do
  default_url_options host: ENV.fetch("APPLICATION_HOST")

  root to: 'home#index'
  mount Sidekiq::Web => '/queue'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users
  devise_for :relations
  devise_for :adviser
  devise_for :supervisor

  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do

      get 'currencies', to: 'currencies#index'

      devise_for :users, path: '', path_names: {
        sign_in: 'login',
        sign_out: 'logout'
      },
      controllers: {
        sessions: 'api/v1/users/sessions'
      }

      resources :countries, only: [:index]
      resources :banks, only: [:index]

      resources :external_real_estates, only: [:index, :update]

      scope :internals do
        get '/aum', to: 'internals#aum'
        get '/clients', to: 'internals#clients'
      end

      resources :relations, only: [:index, :create, :update, :destroy] do
        resources :relation_files, only: [:index, :create]
        resources :accounts, only: [:index, :create, :update, :destroy] do
          collection do
            get '/asset_type/:asset_type', action: :asset_type_filter
          end
        end
        get :investments, action: :get_investments
        get :investments_with_real_estate, action: :get_investments_with_real_estates
        get :investments_with_liabilities, action: :get_investments_with_liabilities
        get :investments_with_others, action: :get_investments_with_others
        get :investments_with_insurances, action: :get_investments_with_insurances
        get :history_balances, action: :get_history_balances
        get :wallet_balances, action: :wallet_balances
        get :chart_history, action: :chart_history
        put :queue_chart_update, action: :queue_chart_update
        resources :money_movements, only: [:index]
        get :balance, action: :balance
        get :assets, action: :get_assets
        resources :summary, only: [:index]
        get 'summary/estate_distribution', to: "summary#estate_distribution"
        get 'summary/estate_distribution_by_currency', to: "summary#estate_distribution_by_currency"
        get 'summary/estate_distribution_by_country', to: "summary#estate_distribution_by_country"
        get 'summary/estate_distribution_by_sustainability', to: "summary#estate_distribution_by_sustainability"
        get 'summary/investments_distribution', to: "summary#investments_distribution"
        get 'summary/estate_distribution_by_institution', to: "summary#estate_distribution_by_institution"
        get 'summary/top_investments', to: "summary#top_investments"
        post 'insurances/upload_file', to: 'insurances#upload_file'
        get 'insurances/totals', to: 'insurances#totals'
        get 'summary/get_chart_history', to: 'summary#chart_history'
        resources :others, only: [:index, :create, :update, :destroy, :show]
        resources :insurances, only: [:index, :create, :update]
      end

      resources :relation_files, only: [:update, :destroy]
      get 'relation_files/:id/download', to: 'relation_files#download'
      get 'relation_files/download_multiple', to: 'relation_files#download_multiple'

      resources :memberships, only: [:update] do
        resources :money_movements, only: [:create, :update, :destroy]
        patch :liquidate, action: :liquidate
        patch :enable, action: :enable
        resources :alternative_names, only: [:create]
      end

      resources :accounts do
        resources :sub_accounts, only: [:index, :create, :update, :destroy]
      end

      resources :investment_assets, only: [:create, :index] do
        resources :price_changes, only: [:create]
      end

      resources :money_movements, only: [:update, :destroy]

      resources :sub_accounts do
        get :report, to: 'reports#sub_account_report'
        resources :memberships, only: [:index, :create]
        resources :pension_funds, only: [:index, :create]
        resources :real_estates, only: [:index, :create, :update]
        resources :insurances, only: [:index, :create, :update, :destroy]
        get 'investment_insurances', to: 'insurances#investment_insurances'
        post 'insurances/upload_file', to: 'insurances#upload_file'
        delete 'insurances/delete_file/:id', to: 'insurances#delete_file'
        resources :others, only: [:index, :create, :update, :destroy, :show]
        post 'others/update_external_valorization', to: 'others#update_external_valorization'
        resources :liabilities, only: [:index, :create, :update, :destroy] do
          post 'pay', action: :pay
          get 'money_movements', action: :money_movements
          patch 'money_movements/:money_movement_id', action: :update_money_movement
        end
        post 'real_estates/update_external_valorization', to: 'real_estates#update_external_valorization'
        resources :wallet_deposits, only: [:index, :create, :update, :destroy]
        resources :wallet_withdrawals, only: [:index, :create, :update, :destroy]
        get :month_withdrawals, to: 'wallet_withdrawals#month_movements'
        get :month_deposits, to: 'wallet_deposits#month_movements'
        get :custom_memberships, action: :custom_memberships
        get :membership, action: :membership
        post :custom_asset, action: :custom_asset
        get :roles, action: :roles
      end

      resources :relation_histories, only: [:update]
    end

    api_version(module: 'Api::V2', path: { value: 'v2' }, defaults: { format: 'json' }) do
      post 'relations/send_email_to_support', to: 'relations#send_email_to_support'

      # Devise Authentication for users (ADMINS)
      devise_for :user, path: 'auth', path_names: {
        sign_in: 'sign_in',
        sign_out: 'sign_out',
        password: 'password'
      }, controllers: {
        sessions: 'api/v2/auth_session',
        passwords: 'api/v2/auth_password'
      }

      # Devise Authentication for supervisors
      devise_for :supervisor, path: 'auth', path_names: {
        sign_in: 'sign_in',
        sign_out: 'sign_out',
        password: 'password'
      }, controllers: {
        sessions: 'api/v2/auth_session',
        passwords: 'api/v2/auth_password'
      }

      # Devise Authentication for advisers
      devise_for :adviser, path: 'auth', path_names: {
        sign_in: 'sign_in',
        sign_out: 'sign_out',
        password: 'password'
      }, controllers: {
        sessions: 'api/v2/auth_session',
        passwords: 'api/v2/auth_password'
      }

      # Devise Authentication for investor (RELATIONS)
      devise_for :relation, path: 'auth', path_names: {
        sign_in: 'sign_in',
        sign_out: 'sign_out',
        password: 'password'
      }, controllers: {
        sessions: 'api/v2/auth_session',
        passwords: 'api/v2/auth_password'
      }

      devise_scope :user do
        post 'auth/reset_password', to: 'auth_password#reset_password'
        post 'auth/change_password', to: 'auth_password#change_password'
      end
      devise_scope :supervisor do
        post 'auth/reset_password', to: 'auth_password#reset_password'
        post 'auth/change_password', to: 'auth_password#change_password'
      end
      devise_scope :adviser do
        post 'auth/reset_password', to: 'auth_password#reset_password'
        post 'auth/change_password', to: 'auth_password#change_password'
      end
      devise_scope :relation do
        post 'auth/reset_password', to: 'auth_password#reset_password'
        post 'auth/change_password', to: 'auth_password#change_password'
      end

      post 'auth/reset_password', to: 'auth_password#reset_password'
      post 'auth/change_password', to: 'auth_password#change_password'

      scope path: 'adviser' do
        get '/', to: 'adviser#index'
        get 'investors', to: 'adviser#investors'
        get 'investors_complex', to: 'adviser#investors_complex'
        get 'resume', to: 'adviser#resume'
      end

      get 'currencies', to: 'currencies#index'

      resources :relations, only: [:index, :create, :show, :update, :destroy] do
        resources :money_movements, only: [:index]
        get :balance, action: :balance
        match :photo, action: :upload_photo, via: [:post]
        get :investments, action: :get_investments
        get :investments_with_real_estate, action: :get_investments_with_real_estates
        resources :accounts, only: [:index, :create, :update, :destroy] do
          collection do
            get '/asset_type/:asset_type', action: :asset_type_filter
          end
        end
        get 'insurances/totals', to: 'insurances#totals'
      end

      scope path: 'supervisor' do
        get '/', to: 'supervisor#get_current'
        get 'all', to: 'supervisor#get_all'
        get 'resume', to: 'supervisor#resume'
        post '/', to: 'supervisor#create'
        patch '/', to: 'supervisor#update'
        patch '/:supervisor_id', to: 'supervisor#update_supervisor'
        get 'all/:supervisor_id', to: 'supervisor#get_supervisor'
        get 'all/:supervisor_id/advisers', to: 'supervisor#get_supervisor_advisers'

        # CRUD Advisers
        get 'advisers', to: 'supervisor#get_advisers'
        get 'advisers/:adviser_id', to: 'supervisor#show_adviser'
        post 'advisers', to: 'supervisor#create_adviser'
        patch 'advisers/:adviser_id', to: 'supervisor#update_adviser'
        delete 'advisers/:adviser_id', to: 'supervisor#destroy_adviser'
        post 'advisers/:adviser_id/investors/:relation_id', to: 'supervisor#add_investor_to_adviser'
        delete 'advisers/:adviser_id/investors/:relation_id', to: 'supervisor#delete_investor_on_adviser'
        get 'advisers/:adviser_id/investors', to: 'supervisor#get_adviser_investors'
        get 'advisers/:adviser_id/resume', to: 'supervisor#adviser_resume'

        # CRUD Investors
        get 'investors', to: 'supervisor#get_investors'
        get 'investors/complex', to: 'supervisor#get_investors_complex'
        get 'investors/:relation_id', to: 'supervisor#show_investor'
        post 'investors', to: 'supervisor#create_investor'
        patch 'investors/:relation_id', to: 'supervisor#update_investor'
        delete 'investors/:relation_id', to: 'supervisor#destroy_investor'
      end

      resources :users  do
        match :password, action: :update_password, via: [:get, :post]
      end

      get '/enums', to: 'utils#get_enums'
    end
  end

  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  get 'relations', to: 'home#relations'

  scope '/sessions' do
    put ':user_type/update_password', to: 'sessions#update_password', as: :update_password
    get ':user_type/change_password', to: 'sessions#edit_password', as: :change_password
    get ':user_type/recovery_password', to: 'sessions#recovery_password', as: :recovery_password
    post ':user_type/reset_password', to: 'sessions#reset_password', as: :reset_password
  end

  resources :relations, only: [:show] do
    resources :money_movements, only: [:index]
    resources :reports, only: [:index]
    resources :assets_metrics, only: [:index]
    get 'get_pdf', to: 'relations#get_pdf'
    get 'get_xls', to: 'relations#get_xls'
  end

  get '/api/v1/relations/:relation_id/pdf', to: 'relations#get_pdf'
  get '/api/v1/relations/:relation_id/xls', to: 'relations#get_xls'
end
