Rails.application.routes.draw do
  resources :dogs, only: %i[create index update]
  resources :cats, only: %i[create index]
end
