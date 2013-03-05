StargazeRails::Application.routes.draw do
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  namespace :astro do
    resources :constellations, :only=>[:index, :show]
    resources :messiers, :only=>[:show]
    resources :ngcs, :only=>[:show]
    resources :stars, :only=>[:show]
  end

  root :to => 'home#index'
end
