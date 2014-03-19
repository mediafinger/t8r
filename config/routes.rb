T8r::Application.routes.draw do
  root                            to: 'pages#home',      via: :get

  resources :apps,    only: [:index, :show, :edit, :new, :update, :create] do
    resources :locales,       only: [:index, :show, :edit, :new, :update, :create]
    resources :phrases,       only: [:index, :show, :edit, :new, :update, :create, :destroy]
    resources :translations,  only: [:index, :show, :edit, :new, :update, :create]

    get   'import/yaml'           => 'import#yaml'
    post  'import/yaml'           => 'import#upload_yaml'
    get   'import/obc'            => 'import#obc'
    post  'import/obc'            => 'import#upload_obc'
    get   'export'                => 'export#show'
    post  'export/yaml'           => 'export#download_yaml'
    # post  'export/obc'            => 'export#download_obc'
  end
end
