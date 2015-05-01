module LittleBigAdmin
  class ApplicationController < ::ApplicationController

    class_attribute :type_name

    helper "little_big_admin/application"
    include Rails.application.routes.url_helpers

    before_filter :_reload_objects
    before_filter :little_big_admin_user
    before_filter :little_big_admin_authorize

    before_filter :little_big_admin_menu

    def _reload_objects
      LittleBigAdmin.load_all_objects unless Rails.application.config.cache_classes
    end

    def little_big_admin_user 
      instance_exec(&LittleBigAdmin.config.current_user)
    end

    def little_big_admin_authorize
      @lba_object = LittleBigAdmin::Registrar.get(self.type_name, params[:admin_model_id] || params[:id])

      return render_little_big_admin_404 unless @lba_object

      authorized = @lba_object.permitted?(instance_exec(&LittleBigAdmin.config.current_permission))

      if !authorized
        target = instance_exec(&LittleBigAdmin.config.login_path)
        redirect_to target
      end
    end

    def render_little_big_admin_404
      render "/little_big_admin/shared/404"
    end

    def set_title(title=nil)
      @lba_page_title = title
    end

    def little_big_admin_menu
      @lba_menu = LittleBigAdmin::Registrar.menu do |obj|
        obj.permitted?(instance_exec(&LittleBigAdmin.config.current_permission))
      end
    end

    helper_method :set_title
  end
end
