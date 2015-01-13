module LittleBigAdmin
  module ApplicationHelper

    def admin_item_href(item)
      if item.is_a?(LittleBigAdmin::Page)
        admin_page_path(item.name)
      else
        admin_model_items_path(item.name)
      end
    end
  end
end
