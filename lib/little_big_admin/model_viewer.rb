class LittleBigAdmin::ModelViewer

  def initialize(model,view_context)
    @model = model
    @view_context = view_context
  end

  def show(item)
    run_builder(item) do |builder|
      builder.stacked(&@model.show_block)
    end
  end

  def form(item)
    run_builder(item) do |builder|
      builder.form_fields(@model.name, item, &@model.form_block)
    end
  end

  def table(item_list)
    run_builder do |builder|
      builder.table(item_list, &@model.index_block)
    end
  end

  def run_builder(item = nil,&block)
    view_builder = LittleBigAdmin::ViewBuilder.new(@view_context,item)
    yield view_builder
    view_builder.build
  end
end
