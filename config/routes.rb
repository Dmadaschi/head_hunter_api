Rails.application.routes.draw do
  mount_devise_token_auth_for 'Applicant', at: 'applicant_auth'

  mount_devise_token_auth_for 'HeadHunter', at: 'head_hunter_auth'

  namespace :v1 do
    resources :opportunities, only: %i[create show index] do
      member do
        post :apply
      end
    end
    resources :applicant_profiles, only: %i[create update]
  end
end
