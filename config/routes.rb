Rails.application.routes.draw do
  resources :courses
  resources :sites
  resources :contacts
  resources :fellows
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
