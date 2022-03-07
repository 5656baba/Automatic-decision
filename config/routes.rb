Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admin/sessions'
  }
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
  end
  scope module: :user do
    resources :informations, only: [:show, :edit, :update] do
      collection do
        get 'unsubscribe'
        patch 'withdraw'
      end
    end
    root to: 'homes#top'
  end
  devise_for :users
  resources :contacts, only: [:new, :create]
  get 'thanks', to: 'contacts#thanks'
  post 'check', to: 'contacts#check'
  post 'contacts/back', to: 'contacts#back', as: 'back'
end
