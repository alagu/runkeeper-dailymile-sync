Rkdm::Application.routes.draw do
  match "/auth/:provider/callback" => "sessions#create"
  match "/signup" => "users#new", :as => :signup
  match "/signout" => "sessions#destroy", :as => :signout
  match "/account" => "users#edit", :as => :account
  match "/admin" => "admin#show", :as => :admin
  namespace :admin do
    resources :users, :only => :index
  end
  resources :users, :only => [:edit, :update]
  root :to => "dashboard#show"
end
