class LittleBigAdmin::ItemsController < LittleBigAdmin::ApplicationController

  before_filter :get_model

  self.type_name = "model"

  def index
    set_title(@model.title)
    @item_list = @restful_model.list(params)
    @result = model_viewer.table(@item_list.items)
  end

  def show
    @item = @restful_model.get(item_id)
    return render_little_big_admin_404 unless @item

    set_title("#{@model.instance_name_block.call(@item)} > #{@model.instance_title}")

    @result = model_viewer.show(@item)
  end

  def new
    set_title("New #{@model.instance_title}")
    @item ||= @restful_model.new
    @result = model_viewer.form(@item)
    render action: "new"
  end

  def create
    @item = @restful_model.create(item_params)

    if @item.valid?
      return redirect_with_notice(@item,"created") 
    else
      self.new
    end
  end

  def edit
    @item ||= @restful_model.get(item_id)

    @result = model_viewer.form(@item)

    set_title("Edit #{@model.instance_name_block.call(@item)} > #{@model.instance_title}")
    render action: "edit"
  end

  def update
    @item = @restful_model.update(item_id, item_params)

    if @item.valid?
      return redirect_with_notice(@item,"updated") 
    else
      self.edit
    end
  end
  
  def destroy
    @item =  @restful_model.destroy(item_id)
    redirect_with_notice(@item,"destroyed")
  end

  protected

  def redirect_with_notice(item,action_verb)
    flash[:notice] = "#{@model.instance_title} \"#{@model.name_of(item)}\" has been #{action_verb}"
    redirect_to admin_model_items_path(@model.name)
  end

  def model_viewer
    @model_viewer ||= LittleBigAdmin::ModelViewer.new(@model,view_context)
  end

  def get_model
    @model = LittleBigAdmin::Registrar.get(:model,item_name)
    return render_little_big_admin_404 unless @model
    @current_model_name = @model.name
    @restful_model = LittleBigAdmin::RestfulModel.new(@model)
  end

  def item_name
    params[:admin_model_id].to_s.singularize.to_sym
  end

  def item_id
    params[:id].to_s
  end

  def item_params
    params[@model.name].to_hash
  end

end
