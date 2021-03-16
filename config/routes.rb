Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      patch 'make_it_best', on: :member
      patch 'delete_file', on: :member
    end
    patch 'delete_file', on: :member
  end

  
end
