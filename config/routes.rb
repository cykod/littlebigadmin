LittleBigAdmin::Engine.routes.draw do

  resources :models, as: :admin_model, only: [] do

    resources :items, path: "" do
      collection do 
        resources :lists, only: :show
      end

      get "actions/:action" => "model_actions#show", as: "action"
      patch "actions/:action" => "model_actions#patch"
    end
  end

  resources :graphs, only: :show, as: :admin_graph
  resources :pages, only: :show, as: :admin_page
end
