module LittleBigAdmin
  module ApplicationHelper

    def admin_item_href(item)
      if item.is_a?(LittleBigAdmin::Page)
        admin_page_path(item.name)
      else
        admin_model_items_path(item.name)
      end
    end


    def admin_item_class(item)
      active = if item.is_a?(LittleBigAdmin::Page)
        item.name == @current_page_name
      else
        item.name == @current_model_name
      end

      active ? "active" : ""
    end
  end


end
