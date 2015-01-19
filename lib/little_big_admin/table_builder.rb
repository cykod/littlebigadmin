class LittleBigAdmin::TableBuilder
  include LittleBigAdmin::Engine.routes.url_helpers

  def initialize(objects,view)
    @view = view
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

  def default_actions
    @columns.push([ :actions ])
  end

  def setup(&block)
    instance_eval &block
    self
  end

  def build
    [ thead, tbody ]
  end

  def thead
    @view.content_tag(:thead,
                      @view.content_tag(:tr,
                                        @view.safe_join(@columns.map do |col|
                                          @view.content_tag(:td, col[1].to_s.humanize)
                                        end)))
  end

  def tbody
    @view.content_tag(:tbody,
                      @view.safe_join(@objects.map do |obj|
                        @view.content_tag(:tr,
                          @view.safe_join(@columns.map do |col|
                            table_render_cell(obj,col)
                          end))
                      end))
  end

  def table_render_cell(obj, col)
    val = self.send("table_render_#{col[0]}", obj, col)
    @view.content_tag(:td, val)
  end

  protected

  def table_render_checkbox(obj, col)
    "<input type='checkbox' />".html_safe
  end

  def table_render_actions(obj,col)
    model = LittleBigAdmin.model_for(obj)
    @view.safe_join([
      @view.link_to("View", admin_model_item_path(model.name, obj.id), class: 'button-lightgray smaller'),
      @view.link_to("Edit", edit_admin_model_item_path(model.name, obj.id), class:'button-lightgray smaller'),
      @view.link_to("X", admin_model_item_path(model.name, obj.id), class:'button-lightgray smaller', method: "delete")
    ], " ")
  end

  def table_render_column(obj,col)
    if col[3]
      @view.instance_exec obj, &col[3]
    else
      LittleBigAdmin::Formatter.format(obj, col[1], col[2])
    end
  end

  def table_render_linked_column(obj,col)
    model = LittleBigAdmin.model_for(obj)
    val = table_render_column(obj, col)
    if model
      @view.link_to val, admin_model_item_path(model.name, obj.id)
    else
      val
    end
  end

end



