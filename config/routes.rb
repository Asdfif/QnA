Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  patch 'answers/:id/make_it_best', to: 'answers#make_it_best', as: "make_it_best"

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy]
  end
end
