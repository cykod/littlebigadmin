class LittleBigAdmin::Model < LittleBigAdmin::Base

  def self.base_settings

    setting :menu do
      [ @name.to_s.humanize, { priority: 0 } ]
    end

    setting :name do
      @name
    end

    setting :plural_name do
      @name.to_s.pluralize.to_sym
    end

    setting :instance_name do
      ->(model) { model.name }
    end

  end

  def self.scope_settings

    setting :base_scope do
     -> { @name.to_s.classify.constantize }
    end

    setting :new_model do
      -> { self.base_scope_block.call.new }
    end

    setting :find_model do |id|
      -> { self.base_scope_block.find(id) }
    end

    list_setting :scope do
      [ :all ]
    end

    list_setting :filter

  end

  def self.page_settings

    list_setting :collection_action

    setting :index
    setting :show
    setting :form

  end

  base_settings
  scope_settings
  page_settings
end
