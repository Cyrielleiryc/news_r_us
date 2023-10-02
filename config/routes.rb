Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :posts, only: %i[index show new create] do
    resources :comments, only: %i[create]
  end

  get 'my_posts', to: "posts#my_posts"
end
