Rails.application.routes.draw do
  resources :shops, only: [:index, :show] do
    get :vending, on: :collection
    get :buying, on: :collection
  end
  resources :items, only: [:index, :show] do
    get :opportunities, on: :collection
  end

  root 'home#index'
end
