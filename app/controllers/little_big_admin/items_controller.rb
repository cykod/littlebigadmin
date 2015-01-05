class LittleBigAdmin::ItemsController < LittleBigAdmin::ApplicationController

  before_filter :get_model
  

  def index
    scope = @model.base_scope_block.call

    view_builder = LittleBigAdmin::ViewBuilder.new(view_context)
    view_builder.table(scope.all, &@model.index_block)

    @result = view_builder.render
  end

  def show
    item = @model.find_model_block.call(params[:id].to_s)

    view_builder = LittleBigAdmin::ViewBuilder.new(view_context,item)
    view_builder.grid(&@model.show_block)

    @result = view_builder.render
  end

  def new
    item = @model.new_model_block.call

    view_builder = LittleBigAdmin::ViewBuilder.new(view_context,item)
    view_builder.form(item_name, item, &@model.form_block)

    @result = view_builder.render

    render action: 'form'
  end

  protected


  def get_model
    @model = LittleBigAdmin::Registrar.get(:model,item_name)
  end

  def item_name
    params[:model_id].to_s.singularize.to_sym
  end

end
