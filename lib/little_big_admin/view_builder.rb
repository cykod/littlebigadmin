class LittleBigAdmin::ViewBuilder

  include ActionView::Helpers::TagHelper 
  include ActionView::Helpers::OutputSafetyHelper


  def initialize(view_context,object = nil)
    @view_context = view_context
    @stack = [[]]
    @objects = []
    @objects.push(object) if object
  end

  def panel(name, options = {},&block)
    push_tag(:div, options,
            [ 
              add_tag(:fieldset, { class: "flakes-information-box" }, 
                      [ add_tag(:legend, {}, name) ] + nested_content(&block))
            ])
  end

  def grid(object = nil, options = {}, &block)
    if object.is_a?(Hash)
      options = object
      object = nil
    end
    with_object(object) do
      size, content =  nested_grid_content(&block)
      push_tag(:div, grid_options(size,options), content)
    end
  end

  def block(tag_name, options = {}, &block)
    push_tag(tag_name, options, nested_content(&block))
  end

  def field(name, options = {})
    label = options.delete(:label) || name.to_s.humanize

    value = object.send(name).to_s

    push_tag(:dl,options, 
             [ 
               add_tag(:dt, {}, label),
               add_tag(:dd, {}, value)
             ])
  end

  def table(objects,options = {},&block)
    push_tag(:table, 
             { class: "flakes-table" }, 
             LittleBigAdmin::TableBuilder.new(objects, self).setup(&block).render)
  end

  def form(item_name, item, &block)
    form_builder = LittleBigAdmin::FormBuilder.new(item_name, item, self)

    form_builder.form do |form_builder|
      instance_exec form_builder, &block
    end
  end

  def object
    @objects.last
  end

  def render(&block)
    instance_eval(&block) if block

    # take the top of the stack
    resolve_content(@stack.pop)
  end

  def with_object(object, &block)
    @objects.push(object) if object
    yield
    @objects.pop(object) if object
  end

  def method_missing(method_name, *args, &block)
    @view_context.send(method_name, *args, &block)
  end

  def push_resolved(string, options = {})
    @stack.last.push([ string, options ])
  end

  protected


  def add_tag(name, options, content)
    content_tag(name, resolve_content(content), options)
  end


  def push_tag(name, options, content)
    @stack.last.push( [ name, options, resolve_content(content) ])
  end

  def add_class(name, base = nil)
    base ||= {}
    cls = base[:class] ? (base[:class] + " ") : ""
    cls += name

    base.merge(class: cls)
  end

  def grid_options(size, base = {})
    return base || {} unless size
    if base && base[:gutter]
      gutter = " gutter-#{base.delete(:gutter)}"
    end
    add_class("grid-#{size}#{gutter}", base)
  end

  def resolve_content(content)
    return "".html_safe unless content.present?

    content = [ content ] unless content.is_a?(Array)
    safe_join(content.map do |tag|
      tag.is_a?(String) ? tag : 
        tag.length == 3 ? content_tag(tag[0], tag[2], tag[1]) :
        tag[0]
    end)
  end

  def nested_content(&block)
    return nil unless block
    push_stack
    
    result = self.instance_eval(&block)
    if result.is_a?(String)
      @stack.last.push(result)
    end

    pop_stack 
  end

  def nested_grid_content(&block)
    return [ nil, [] ] unless block
    result = nested_content(&block)

    size = add_spans(result)

    return [ size, result ]
  end

  def add_spans(tags)
    total = tags.inject(0) { |acc, t| acc + (t[1][:size] || 1) }
    tags.each do |t|
      size = t[1][:size] || 1
      t[1] = add_class("span-#{size}",t[1])
      t[1].delete(:size)
    end
    total
  end

  def push_stack
    @stack.push([])
  end

  def pop_stack
    @stack.pop
  end


end
