Rails.application.routes.draw do
  root 'posts#index'
  # route for autosaving post drafts with same id as post
  patch '/posts/:id/autosave', to: 'posts#autosave', as: 'autosave_post'

  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
