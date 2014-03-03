T8r::Application.routes.draw do
  root                            to: 'pages#home',      via: :get

  resources :apps,    only: [:index, :show, :edit, :new, :update, :create] do
    resources :locales,       only: [:index, :show, :edit, :new, :update, :create]
    resources :phrases,       only: [:index, :show, :edit, :new, :update, :create, :destroy]
    resources :translations,  only: [:index, :show, :edit, :new, :update, :create]

    get   'import'                => 'import#show'
    post  'import/upload_yaml'    => 'import#upload_yaml'
    get   'export'                => 'export#show'
    post  'export/download_yaml'  => 'export#download_yaml'
  end
end
