module LittleBigAdmin
  class ApplicationController < ::ApplicationController

    class_attribute :type_name

    helper "little_big_admin/application"
    include Rails.application.routes.url_helpers

    before_filter :_reload_objects
    before_filter :little_big_admin_authorize

    before_filter :little_big_admin_menu

    def _reload_objects
      LittleBigAdmin.load_all_objects unless Rails.application.config.cache_classes
    end

    def little_big_admin_user 
      instance_exec(&LittleBigAdmin.config.current_user)
    end

    def little_big_admin_authorize
      authorized = instance_exec(self.type_name, params[:admin_model_id] || params[:id],params[:action],&LittleBigAdmin.config.authorize) if little_big_admin_user
      if !little_big_admin_user || !authorized
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
        type_name = obj.is_a?(LittleBigAdmin::Model) ? "model" : "page"
        action_name = type_name == "model" ? "index" : "show"
        authorized =  instance_exec(type_name, obj.name.to_s, action_name ,&LittleBigAdmin.config.authorize)
        little_big_admin_user  && authorized
      end
    end

    helper_method :set_title
  end
end
