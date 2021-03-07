Rails.application.routes.draw do
  mount_devise_token_auth_for 'Applicant', at: 'applicant_auth'

  mount_devise_token_auth_for 'HeadHunter', at: 'head_hunter_auth'
  as :head_hunter do
    # Define routes for HeadHunter within this block.
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
