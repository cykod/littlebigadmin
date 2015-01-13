class LittleBigAdmin::GraphBuilder

  def initialize(name,view,options = {})
    @name = name
    @graph = LittleBigAdmin::Registrar.get(:graph,name)
    @view = view
    @options = options
    raise "Invalid Graph #{name}" unless @graph
  end

  def build
    height = @graph.height
    @view.safe_join [ 
      @graph.name && @view.content_tag("h3", @graph.name ),
      @view.content_tag("div", "", id: "#{@name}_chart", style: "height: #{height}px" ),
      graph_javascript
    ].compact
  end


  def graph_javascript
    "<script> $(document).on(\"ready page:load\", function() { c3.generate(#{graph_data.to_json}); })</script>".html_safe
  end


  def graph_data
    columns = @graph.columns_block.call.to_a.map { |series| series.flatten }
    x_axis = columns.detect { |c| c[0] == "x" }


    details = {
      bindto: "##{@name}_chart",
      data: {
        columns: columns,
        type: @graph.type
      }
    }

    add_axis(details, x_axis)

    details
  end

  def add_axis(details, x_axis)
    return unless x_axis

    if timeseries?(x_axis)
      add_timeseries_axis(details,x_axis)
    elsif category_axis?(x_axis)
      add_category_axis(details,x_axis)
    end

    details[:data][:x] = "x"
  end

  def add_timeseries_axis(details,x_axis)
    x_axis.map! { |dt|
      if dt.is_a?(Time)    
        dt.to_date.to_s 
      else
        dt
      end
    }
    details[:axis] = {
      x: {
        type: "timeseries",
        tick: { 
          format: "%m/%d/%Y"
        }
      }
    }
  end

  def add_category_axis(details,x_axis)
    details[:data][:columns] -= x_axis
    details[:axis] = {
      x: {
        type: "category",
        categories: x_axis[1..-1]
      }
    }
  end

  def category_axis?(x_axis)
    !x_axis[1].is_a?(Numeric)
  end

  def timeseries?(x_axis)
    x_axis[1].is_a?(Date) || x_axis[1].is_a?(Time)
  end
end
