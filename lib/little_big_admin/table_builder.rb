class LittleBigAdmin::TableBuilder
  def initialize(objects,view)
    @view = view
    @objects = objects
    @columns = []
  end

  def column(name, options ={})
    @columns.push([ :column, name, options ])
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

  def render
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
                            @view.content_tag(:td, obj.send(col[1]))
                          end))
                      end))
  end

end



