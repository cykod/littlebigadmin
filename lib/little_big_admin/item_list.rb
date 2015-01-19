class ItemList

  def initialize(model, options)
    @model = model
    @options = slice_options(options)
  end

  attr_reader :items, :options, :pagination


  def generate
    base_scope = @model.base_scope_block.call
    
    search_scope = run_search(base_scope)

    paginated_scope, @pagination = paginate(search_scope)

    ordered_scope = run_order(paginated_scope)

    @items = ordered_scope.all
    self
  end

  def slice_options(options)
    options.slice("page","q","filter")
  end

  def query(override = {})
    @options.merge(override)
  end


  def run_search(scope)
    scope
  end

  def paginate(scope)
    pagination = if @model.show_total
      paginate_total(scope)
    else
      paginate_no_total(scope)
    end
    [ scope.offset(offset).limit(limit), pagination ]
  end

  def paginate_total(scope)
    pages = total_pages(scope)
    {
      page: page,
      next_page: page < pages ? (page + 1) : nil,
      last_page: page > 1 ? (page - 1) : nil,
      pages: pages
    }
  end

  def paginate_no_total(scope)
    has_next_page = scope.offset(offset + 1).limit(1).first
    {
      page: page,
      next_page: has_next_page ? (page + 1) : nil,
      last_page: page > 1 ? (page-1) : nil,
    }
  end

  def offset
    (page - 1) * @model.per_page
  end

  def limit
    @model.per_page
  end

  def page
    (@options[:page] || 1).to_i
  end

  def total_pages(scope)
    [1, (scope.count.to_f / @model.per_page).ceil].max
  end

  def run_order(scope)
    scope
  end


end
