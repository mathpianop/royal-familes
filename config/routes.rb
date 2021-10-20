Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "people#index"
  resources :people
  get "autocomplete", to: "people#autocomplete"
  get "relationship/:id/:relation_id", to: "people#relationship"
end
