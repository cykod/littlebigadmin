LittleBigAdmin::Engine.routes.draw do
  namespace :little_big_admin, path: "", as: "lba" do

    resources :models, only: [] do

      resources :items, path: "" do
        collection do 
          resources :lists, only: :show
        end

        get "actions/:action" => "model_actions#show", as: "action"
        patch "actions/:action" => "model_actions#patch"
      end
    end

    resources :graphs, only: :show
    resources :pages, only: :show
  end
end
