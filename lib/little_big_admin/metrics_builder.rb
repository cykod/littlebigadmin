class LittleBigAdmin::MetricsBuilder
  include ActionView::Helpers::NumberHelper

  def initialize(view_builder, options)
    @view_builder = view_builder
    @options = options
    @stats = []
  end

  def setup(&block)
    yield self
    self
  end

  def build_stat(stat)
    href = stat[:href]
    @view_builder.push_tag(:div,  {},
      @view_builder.add_tag(href ? :a : :div, { class: 'lba-metric', title: stat[:description], href: href },
                           [
                             stat[:name],
                             build_value(stat),
                             @view_builder.add_tag(:i, {}, stat[:subtitle])
                            ]))
  end

  def build_value(stat)
    value =  LittleBigAdmin::Formatter.run(stat[:value], stat[:format] || :default, stat[:format_options] || {})
    if stat[:percent]
      number = number_to_percentage(stat[:percent]*100, precision:2, strip_insignificant_zeros: true)
      percent = " ".html_safe + if stat[:percent] > 0
                        @view_builder.content_tag(:span, "(+#{number})", class: 'percent up')
                      else
                        @view_builder.content_tag(:span, "(#{number})", class: 'percent down')
                      end

    end
    @view_builder.add_tag(:span, {}, 
                          [ value, percent ].compact)

  end

  def stat(name, value, options = {})
    build_stat(options.merge(name: name, value: value))
    # @stats.push()


  end
end
