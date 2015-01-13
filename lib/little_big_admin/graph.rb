class LittleBigAdmin::Graph < LittleBigAdmin::Base

  def self.graph_settings

    setting :name

    setting :cache_for

    setting :height, 320

    setting :type, :line

    setting :x_axis
    setting :y_axis

    list_setting :filter

    setting :columns

  end

  graph_settings


end
