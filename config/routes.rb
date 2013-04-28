StargazeRails::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  namespace :astro do
    resources :constellations, :only=>[:index, :show]
    resources :messiers, :only=>[:show]
    resources :ngcs, :only=>[:show]
    resources :stars, :only=>[:show]
    resources :solars, :only=>[:index, :show]
  end

  namespace :addable do
    resources :observations
  end

  resources :comments

  match "/info",                  :to =>"home#info"
  match "/votes/add_to_fav",      :to =>"votes#add_to_fav"
  match "/votes/remove_from_fav", :to =>"votes#remove_from_fav"
  root :to => 'home#index'
end
