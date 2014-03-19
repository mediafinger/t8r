T8r::Application.routes.draw do
  root                            to: 'pages#home',      via: :get

  resources :apps,    only: [:index, :show, :edit, :new, :update, :create] do
    resources :locales,       only: [:index, :show, :edit, :new, :update, :create]
    resources :phrases,       only: [:index, :show, :edit, :new, :update, :create, :destroy]
    resources :translations,  only: [:index, :show, :edit, :new, :update, :create]

    match 'import/yaml',   to: 'import#yaml',          via: :get
    match 'import/yaml',   to: 'import#upload_yaml',   via: :post
    match 'import/obc',    to: 'import#obc',           via: :get
    match 'import/obc',    to: 'import#upload_obc',    via: :post
    match 'export',        to: 'export#show',          via: :get
    match 'export',        to: 'export#download',      via: :post
  end
end
