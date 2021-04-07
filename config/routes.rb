Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member do 
      post :vote_for
      post :vote_against
      delete :cancel_vote
    end
  end

  resources :users, only: %i[] do
    get 'rewards', on: :member
  end

  resources :questions, concerns: %i[votable] do
    resources :answers, shallow: true,
                        concerns: %i[votable],
                        only: %i[create update destroy] do
      patch 'make_it_best', on: :member
      resources :comments, shallow: true, only: %i[create]
    end
    resources :comments, shallow: true, only: %i[create]
  end

  resources :attachments, only: %i[] do
    delete 'delete_file', on: :member
  end
  
  resources :links, only: %i[destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :others, on: :collection
      end
      resources :questions, only: %i[index show create] do
        resources :answers, only: %i[index show create]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
