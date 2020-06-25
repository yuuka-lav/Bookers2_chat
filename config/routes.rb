Rails.application.routes.draw do
	devise_for :users
  resources :users,only: [:show,:edit,:update,:index]
  resources :books
  root 'home#top'
  get 'home/about'
  resources :chats,only: [:show]
  post 'chats/:room_id', to: 'chats#create'
end
