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
    push_tag(:div, add_class("flakes-panel",options),
            [ 
              add_tag(:fieldset, { class: "flakes-information-box" }, 
                       (name.present?  ? [ add_tag(:legend, {}, name) ] : []) + nested_content(&block))
            ])
  end

  def grid(object = nil, options = {}, &block)
    if object.is_a?(Hash)
      options = object
      object = nil
    end
    options[:gutter] ||= 20
    with_object(object) do
      size, content =  nested_grid_content(&block)
      push_tag(:div, grid_options(size,options), content)
    end
  end

  def stacked(&block)
    push_resolved(content_tag("div", resolve_content(nested_content(&block))))
  end

  def block(tag_name, options = {}, &block)
    push_tag(tag_name, options, nested_content(&block))
  end

  def field(name, options = {})
    label = options.delete(:label) || name.to_s.humanize

    display = if block_given?
              value = yield object
              as = options.delete(:as) || LittleBigAdmin::Formatter.choose_format(value)
              LittleBigAdmin::Formatter.run(value, as, options)
            else
              LittleBigAdmin::Formatter.format(object,name, options )
            end

    push_tag(:dl,{}, 
             [ 
               add_tag(:dt, {}, label),
               add_tag(:dd, {}, display)
             ])
  end

  def graph(name, options ={})
    graph_builder = LittleBigAdmin::GraphBuilder.new(name,self,options)

    push_resolved(graph_builder.build)
  end

  def table(objects,options = {},&block)
    push_tag(:table, 
             { class: "flakes-table" }, 
             LittleBigAdmin::TableBuilder.new(objects, self).setup(&block).build)
  end

  def metrics(name = nil, options = {}, &block)
    grid(class: "lba-metrics", gutter: 0) do
      LittleBigAdmin::MetricsBuilder.new(self,options).setup(&block)
    end
  end

  def form_fields(item_name, item, options = {}, &block)
    form_builder = LittleBigAdmin::FormBuilder.new(item_name, item, self)

    form_builder.form do |form_builder|
      instance_exec form_builder, &block
    end
  end

  %w(h1 h2 h3 h4 h5 p).each do |tg|
    define_method tg do |value,options={}|
      push_tag(tg, options, value)
    end
  end

  def object
    @objects.last
  end

  def build(&block)
    instance_eval(&block) if block

    # take the top of the stack
    resolve_content(@stack.pop)
  end

  def with_object(object, &block)
    @objects.push(object) if object
    yield
    @objects.pop(object) if object
  end

  def render(*args)
    push_resolved(@view_context.send(:render, *args))
  end

  def method_missing(method_name, *args, &block)
    @view_context.send(method_name, *args, &block)
  end

  def push_resolved(string, options = {})
    @stack.last.push([ string, options ])
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

  def resolve_content(content)
    return "".html_safe unless content.present?

    content = [ content ] unless content.is_a?(Array)
    safe_join(content.map do |tag|
      tag.is_a?(String) ? tag : 
        tag.length == 3 ? content_tag(tag[0], tag[2], tag[1]) :
        tag[0]
    end)
  end

  def add_tag(name, options, content)
    content_tag(name, resolve_content(content), options)
  end


  def push_tag(name, options, content)
    @stack.last.push( [ name, options, resolve_content(content) ])
  end


  protected


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
