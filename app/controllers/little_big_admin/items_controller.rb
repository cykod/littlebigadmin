class LittleBigAdmin::ItemsController < LittleBigAdmin::ApplicationController
  

  def index

    builder = LittleBigAdmin::ViewBuilder.new(User.last)


    @result = builder.render do
      grid gutter: 20 do
        panel "Basic Info", size: 3 do
          grid do
            field :first_name, size: 2
            field :last_name
          end

          grid do
            field :position
            block :div do
              "Testerama"
            end
          end
        end

        panel "Details" do
          grid do
            field :first_name
          end
          grid do
            field :first_name
          end
        end
      end

      table User.all do
        column :first_name
        column :last_name
      end
    end


  end

end
