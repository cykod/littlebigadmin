module LittleBigAdmin
  module Formatters
    class Model
      extend ActionView::Helpers::TagHelper
      extend ActionView::Helpers::UrlHelper

      def self.format(value,options={})
        model = LittleBigAdmin.model_for(value)

        if model
          name = model.instance_name_block.call(value)
          link_to name, LittleBigAdmin::Engine.routes.url_helpers.admin_model_item_path(model.name, value.id)
        else
          "#{value.name} (#{value.id})"
        end

      end
    end
  end
end
