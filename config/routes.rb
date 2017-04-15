Rails.application.routes.draw do
  devise_for :users

  root 'navigation#index'

  get 'index' => 'navigation#index'
  get 'about' => 'navigation#about'



end
