Rails.application.routes.draw do
  root 'top#index'

  resource :card_uploads, only: %i[new create]

  namespace :apis do
    constraints format: :json do
      resources :people, only: %i[index] do
      end
      resources :cards, only: [] do
        get 'image', on: :member, constraints: { format: 'jpeg' }
      end
    end
  end

  mount MissionControl::Jobs::Engine, at: '/jobs'
end
