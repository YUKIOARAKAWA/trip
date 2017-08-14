Rails.application.routes.draw do
  root 'top#index'

  resources :mypage do
    member do
      get 'top'
    end
  end

  resources :places do
    collection do
      post 'reorder'
    end
  end
  resources :plans do
    collection do
      post 'add'
      post 'add_member'
      post 'datetime'
      get 'modal_restaurant'
      post 'add_restaurant'
    end
    member do
      get 'member'
      get 'confirm'
      get 'pdf'
      get 'finish_mail'
    end
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'top/index'
  resources :blogs

end
