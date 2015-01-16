class LittleBigAdmin::Model < LittleBigAdmin::Base

  def self.base_settings
    setting :instance_title do
      @name.to_s.titleize
    end

    setting :plural_name do
      @name.to_s.pluralize.to_sym
    end

    setting :instance_name do
      ->(model) { model.name }
    end
  end

  def self.menu_settings

    setting :name do
      @name
    end

    setting :menu do
      [ @name.to_s.pluralize.titleize, { priority: 0 } ]
    end

    setting :title do
      @name.to_s.humanize.pluralize.titleize
    end

    setting :instance_title do
      @name.to_s.humanize.titleize
    end

  end

  def self.scope_settings

    setting :base_scope do
     -> { @name.to_s.classify.constantize }
    end

    setting :new_model do
      -> { self.base_scope_block.call.new }
    end

    setting :find_model do
      ->(id) { self.base_scope_block.call.find(id) }
    end

    list_setting :scope do
      [ :all ]
    end

    list_setting :filter

    setting :search do
      nil
    end

  end

  def self.page_settings

    list_setting :collection_action

    setting :index
    setting :show
    setting :form

  end

  menu_settings
  base_settings
  scope_settings
  page_settings

  def name_of(item)
    self.instance_name_block.call(item)
  end
end
