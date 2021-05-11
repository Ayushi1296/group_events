Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users

  resources :group_events do
    post 'publish', on: :member
  end

  match '*path', to: 'application#no_route', via: :all
end
