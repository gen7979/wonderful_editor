Rails.application.routes.draw do
  root to: "home#index"

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "auth/registrations",
      }
      resources :articles
    end
  end
end
