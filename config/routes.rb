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
  # root "posts#index"
  # 
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
    resources :policy_terms do
      member do
        patch :activate # Botão específico para aprovar e ativar um termo
      end
    end
  end
end
