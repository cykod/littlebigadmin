module LittleBigAdmin
  class ApplicationController < ::ApplicationController

    before_filter :_reload_objects
    before_filter :little_big_admin_authorize

    def _reload_objects
      LittleBigAdmin.load_all_objects unless Rails.application.config.cache_classes
    end

    def little_big_admin_user 
      instance_eval(&LittleBigAdmin.config.current_user)
    end

    def little_big_admin_authorize
      authorized = instance_exec(params[:model_id],params[:action],&LittleBigAdmin.config.authorize)
      unless authorized
        target = instance_exec(&LittleBigAdmin.config.login_path)
        redirect_to target
      end
    end

    def render_little_big_admin_404
      render "/little_big_admin/shared/404"
    end
  end
end
