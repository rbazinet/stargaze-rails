StargazeRails::Application.routes.draw do
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  namespace :astro do
    resources :constellations
  end

  root :to => 'home#index'
end
