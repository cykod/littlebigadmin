LittleBigAdmin::Engine.routes.draw do
  get "/", to: "pages#index", as: "admin_root"

  resources :models, as: :admin_models, only: [] do

    resources :items, path: "" do
      collection do 
        resources :lists, only: :show
      end

      get "actions/:action" => "model_actions#show", as: "action"
      patch "actions/:action" => "model_actions#patch"
    end
  end

  resources :graphs, only: :show, as: :admin_graphs
  resources :pages, only: :show, as: :admin_pages
end
