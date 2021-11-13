Rails.application.routes.draw do
  devise_for :admins
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "people#index"
  get "autocomplete", to: "people#autocomplete"
  get "people/search", to: "people#search"
  get "relationship/:id/:relation_id", to: "people#relationship"
  resources :people
end
