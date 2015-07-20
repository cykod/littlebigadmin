class LittleBigAdmin::TableBuilder
  include LittleBigAdmin::Engine.routes.url_helpers

  def initialize(objects,view_context)
    @view_context = view_context
    if @objects.is_a?(ItemList)
      @item_list = @objects
      @objects = @item_list.items
    end
    @objects = objects
    @columns = []
  end


  def column(name, options ={}, &block)
    @columns.push([ :column, name, options, block ])
  end

  def linked_column(name, options = {})
    @columns.push([ :linked_column, name, options ])
  end

  def selectable_column
    @columns.push([ :checkbox ])
  end

  def default_actions(options = {})
    @columns.push([ :actions, "Actions", options ])
  end

  def actions(options = {})
    default_actions(options)
  end

  def setup(&block)
    instance_eval &block
    self
  end

  def build
    [ thead, tbody ]
  end

  def thead
    @view_context.content_tag(:thead,
                      @view_context.content_tag(:tr,
                                        @view_context.safe_join(@columns.map do |col|
                                          @view_context.content_tag(:td, col[1].to_s.humanize)
                                        end)))
  end

  def tbody
    @view_context.content_tag(:tbody,
                      @view_context.safe_join(@objects.map do |obj|
                        @view_context.content_tag(:tr,
                          @view_context.safe_join(@columns.map do |col|
                            table_render_cell(obj,col)
                          end))
                      end))
  end

  def table_render_cell(obj, col)
    table_builder = self
    val = @view_context.nested_content do 
      table_builder.send("table_render_#{col[0]}", obj, col)
    end
    @view_context.content_tag(:td, @view_context.resolve_content(val))
  end


  def method_missing(method_name, *args, &block)
    @view_context.send(method_name, *args, &block)
  end

  protected

  def table_render_checkbox(obj, col)
    "<input type='checkbox' />".html_safe
  end

  def table_render_actions(obj,col)
    model = LittleBigAdmin.model_for(obj)
    options = col[2] || {}

    only = options[:only] || [ :view, :edit, :delete ]

    can_edit = model.edit_permitted?(@view_context.instance_exec(&LittleBigAdmin.config.current_permission))

    only -= [ :edit, :delete ]if !can_edit
      
    actions = []

    actions << @view_context.link_to("View", admin_model_item_path(model.name, obj.id), class: 'button-lightgray smaller') if only.include?(:view)

    actions <<  @view_context.link_to("Edit", edit_admin_model_item_path(model.name, obj.id), class:'button-lightgray smaller') if only.include?(:edit)

    actions << @view_context.link_to("X", admin_model_item_path(model.name, obj.id), class:'button-lightgray smaller', method: "delete", data: { confirm: "Really Delete?" }) if only.include?(:delete)

    @view_context.safe_join(actions, " ")
  end

  def table_render_column(obj,col)
    if col[3]
      @view_context.instance_exec obj, &col[3]
    else
      LittleBigAdmin::Formatter.format(obj, col[1], col[2])
    end
  end

  def table_render_linked_column(obj,col)
    model = LittleBigAdmin.model_for(obj)
    val = table_render_column(obj, col)
    if model
      @view_context.link_to val, admin_model_item_path(model.name, obj.id)
    else
      val
    end
  end

end



