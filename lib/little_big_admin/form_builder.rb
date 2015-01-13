class LittleBigAdmin::FormBuilder
  include LittleBigAdmin::Engine.routes.url_helpers

  def initialize(model_name,object,view_builder)
    @model_name = model_name
    @view_builder = view_builder
    @object = object

  end

  def form(&block)
    @view_builder.fields_for(@object) do |f|
      @form = f
      yield self
    end
  end

  def row(&block) 
    size, content =  nested_form_grid_content(&block)
    push_tag(:div, form_grid_options(size), content)
  end

  def form_grid_options(size, base = {})
    return base || {} unless size
    base ||= {}
    base["data-row-span"] = size
    base
  end

  def nested_form_grid_content(&block)
    return [ nil, [] ] unless block
    result = nested_content(&block)

    size = add_field_spans(result)

    return [ size, result ]
  end

  def add_field_spans(tags)
    total = tags.inject(0) { |acc, t| acc + (t[1][:size] || 1) }
    tags.each do |t|
      size = t[1][:size] || 1
      t[1]["data-field-span"] = size
      t[1].delete(:size)
    end
    total
  end

  def select(field,options = {})
    collection = options.delete(:collection) || []
    field_wrapper(field, options) do
      @form.send(:select, field, @view_builder.send(:options_for_select, collection, @object.send(field) ), options)
    end
  end


  def text_field(field,options = {})
    field(:text_field,field,options)
  end

  def field_wrapper(field, options, &block)
    grid_options = { size: options.delete(:size) || 1}
    push_tag(:div, grid_options, [
      add_tag(:label, {}, options.delete(:label) || field.to_s.titleize),
      yield
    ])
  end

  def field(field_type, field, options)
    field_wrapper(field, options) do
      @form.send(field_type,field,options)
    end
  end



  def method_missing(method_name, *args, &block)
    @view_builder.send(method_name, *args, &block)
  end
end
