class ItemList

  def initialize(model, options)
    @model = model
    @options = slice_options(options)
  end

  attr_reader :items, :options, :pagination


  def generate
    base_scope = @model.base_scope_block.call.all
    
    search_scope = run_search(base_scope)

    filter_scope = run_filters(search_scope)

    view_scope = run_views(filter_scope)

    paginated_scope, @pagination = paginate(view_scope)

    ordered_scope = run_order(paginated_scope)

    @items = ordered_scope.all
    self
  end

  ALL_OPTIONS =  ["page","q","filter", "search", "view"]

  def slice_options(options)
    options.slice(*ALL_OPTIONS) 
  end

  def query(override = {})
    @options.merge(override)
  end

  def options_except(*except)
    options.slice(*(ALL_OPTIONS - except.map(&:to_s)))
  end

  def run_search(scope)
    search_scope = nil

    if options["q"].present? 
      if @model.search_block
        search_scope = @model.search_block.call(options["q"])
      elsif @model.search_value
        search_scope = @model.base_scope_block.call.where( @model.search_value => options["q"])
      end
    end

    return search_scope ? scope.merge(search_scope) : scope
  end

  def run_filters(scope)
    @model.filter_settings.each do |filter|
      key = filter[0].to_s

      if current_filters.has_key?(key)
        if filter[1].is_a?(Proc)
          scope = scope.merge(filter[1].call(current_filters[key]))
        else
          scope = scope.where(key => current_filters[key].to_s)
        end
      end
    end
    scope
  end

  def run_views(scope)
    scope.send(view)
  end

  def current_filters
    @options["filter"] || {}
  end

  def view
    view_setting = @options["view"] || @model.view_settings[0][0]
    if !@model.view_settings.detect { |v| view_setting == v[0].to_s }
      view_setting = @model.view_settings[0][0] 
    end

    view_setting.to_sym
  end

  def q
    @options["q"]
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
    has_next_page = scope.offset(offset + 1 + @model.per_page).limit(1).first
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
    [1, (scope.count(:all).to_f / @model.per_page).ceil].max
  end

  def run_order(scope)
    scope
  end


end
