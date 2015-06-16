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


    def admin_index_href(override = {})
      admin_model_items_path(@model.name,@item_list.query(override))
    end


    def admin_hidden_form_fields(except)
      output = []
      @item_list.options_except(except).each do |key, val|
        output << hidden_field_tag(key, val)
      end
      safe_join(output)
    end

  end


end
