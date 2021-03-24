Rails.application.routes.draw do
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
    end
  end

  resources :attachments, only: %i[] do
    delete 'delete_file', on: :member
  end
  
  resources :links, only: %i[destroy]
end
