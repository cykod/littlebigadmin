class LittleBigAdmin::RestfulModel 

  def initialize(model)
    @model = model
  end


  def list(query_params)
    ItemList.new(@model,query_params).generate
  end

  def new
    new_item
  end

  def get(item_id)
    @model.find_model_block.call(item_id)
  end

  def create(item_params)
    item = new_item
    item = @model.create_model_block.call(item, item_params)
    item
  end

  def update(item_id, item_params)
    item = get(item_id)
    return nil unless item
    item = @model.update_model_block.call(item, item_params)
    item
  end


  def destroy(item_id)
    item = get(item_id)
    return nil unless item
    item.destroy
    item
  end



  protected

  def new_item
    @model.new_model_block.call
  end


end
