class LittleBigAdmin::FormBuilder
  include LittleBigAdmin::Engine.routes.url_helpers

  def initialize(model_name,object,view_builder)
    @model_name = model_name
    @view_builder = view_builder
    @object = object

  end

  def form(&block)
    url = @object.new_record? ? self.lba_model_items_path(@model_name) : self.lba_model_item_path(@model_name,@object)

    @view_builder.fields_for(@object, url: url) do |f|
      @form = f
      yield self
    end
  end


  def text_field(field,options = {})
    grid_options = options.slice(:size)

    @view_builder.push_resolved(@form.text_field(field,options), grid_options)
  end

  def method_missing(method_name, *args, &block)
    @view_builder.send(method_name, *args, &block)
  end
end
