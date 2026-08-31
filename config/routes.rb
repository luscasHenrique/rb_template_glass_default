Rails.application.routes.draw do
 
  devise_for :users
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'graficos', to: 'charts#index', as: :charts

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
 
  resource :cookie_policy, only: [:show], path: 'politica-de-cookies'
  resources :cookie_consents, only: [:create]

  resources :cookie_policies do
      member do
        patch :activate
        get :confirm_destroy
      end
    end
  # Fluxo do Usuário (Bloqueio de Tela)
  resources :terms, only: [] do
    collection do
      get :pending     # Tela de leitura do termo
      post :accept     # Ação de aceitar
      delete :decline  # Ação de recusar (Desloga o usuário)
    end
  end

  # Fluxo do Administrador (Backoffice SaaS)
  namespace :admin do
    resources :users do
      member do
        get :confirm_destroy
      end
    end
    resources :audits, only: [:index, :show]
    resources :policy_terms do
      member do
        patch :activate # Botão específico para aprovar e ativar um termo
        get :confirm_destroy
      end
    end

    resources :cookie_policies do
      member do
        patch :activate
        get :confirm_destroy
      end
    end
  end
end
