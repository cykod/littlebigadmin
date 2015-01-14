class LittleBigAdmin::ItemsController < LittleBigAdmin::ApplicationController

  before_filter :get_model
  

  def index
    scope = @model.base_scope_block.call

    view_builder.table(scope.all, &@model.index_block)

    @result = view_builder.build
  end

  def show
    @item = @model.find_model_block.call(params[:id].to_s)

    view_builder.stacked(&@model.show_block)

    @result = view_builder.build
  end

  def new
    @item = @model.new_model_block.call

    view_builder.form_fields(item_name, @item, &@model.form_block)

    @result = view_builder.build

    render action: 'new'
  end

  def create
    @item = @model.new_model_block.call
    @item.attributes = params[@model.name].to_hash

    if @item.save
      flash[:notice] = "#{@model.instance_title} \"#{@model.name_of(@item)}\" has been created"
      redirect_to admin_model_items_path(@model.name)
    else
      view_builder.form_fields(item_name, @item, &@model.form_block)
      render action: 'new'
    end
  end

  def edit
    @item = @model.find_model_block.call(params[:id].to_s)

    view_builder.form_fields(item_name, @item, &@model.form_block)

    @result = view_builder.build

    render action: 'edit'
  end

  def update
    @item = @model.find_model_block.call(params[:id].to_s)
    @item.attributes = params[@model.name].to_hash

    if @item.save
      flash[:notice] = "#{@model.instance_title} \"#{@model.name_of(@item)}\" has been updated"
      redirect_to admin_model_items_path(@model.name)
    else
      view_builder.form_fields(item_name, @item, &@model.form_block)
      render action: 'edit'
    end
  end
  
  def destroy
    @item = @model.find_model_block.call(params[:id].to_s)

    @item.destroy if @item
    redirect_to action: 'index'
  end

  protected

  def view_builder
    @view_builder ||= LittleBigAdmin::ViewBuilder.new(view_context,@item)
  end

  def get_model
    @model = LittleBigAdmin::Registrar.get(:model,item_name)
    return render_little_big_admin_404 unless @model
    @current_model_name = @model.name
  end

  def item_name
    params[:admin_model_id].to_s.singularize.to_sym
  end

end
