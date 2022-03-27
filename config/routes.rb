Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admin/sessions',
  }
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :destroy]
    resources :comments, only: [:index, :show, :destroy]
  end
  scope module: :user do
    resources :informations, only: [:show, :edit, :update] do
      collection do
        get 'unsubscribe'
        patch 'withdraw'
      end
    end
    resources :resumes, only: [:show, :edit, :destroy]
    resources :posts, only: [:index, :show, :create, :destroy] do
      resources :comments, only: [:create, :destroy] do
        resource :likes, only: [:create, :destroy]
      end
    end
    root to: 'homes#top'
  end
  devise_for :users
  resources :contacts, only: [:new, :create]
  get 'thanks', to: 'contacts#thanks'
  post 'check', to: 'contacts#check'
  post 'contacts/back', to: 'contacts#back', as: 'back'
  get 'search', to: 'search#search'
end
