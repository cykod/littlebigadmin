class LittleBigAdmin::PagesController < LittleBigAdmin::ApplicationController

  include LittleBigAdmin::ApplicationHelper

  before_filter :get_page, only: :show

  self.type_name = "page"

  def index

    dashboard = admin_item_href(@lba_menu.first[1][0])

    if dashboard
      redirect_to dashboard
    else
      render nothing: true, status: 404
    end
  end

  def show
    set_title(@page.title)
    view_builder = LittleBigAdmin::ViewBuilder.new(view_context)
    view_builder.stacked(&@page.show_block)


    @result = view_builder.build
  end


  protected


  def get_page
    @page = LittleBigAdmin::Registrar.get(:page,page_name)
    return render_little_big_admin_404 unless @page
    @current_page_name = @page.name
  end

  def page_name
    params[:id].to_s.to_sym
  end

end
