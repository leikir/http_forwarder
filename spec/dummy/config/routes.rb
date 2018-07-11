Rails.application.routes.draw do
  resources :dummy, only: %i[create index]
end
