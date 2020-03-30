Rails.application.routes.draw do
  resources :shops
  resources :items do
    get :opportunities, on: :collection
  end
end
