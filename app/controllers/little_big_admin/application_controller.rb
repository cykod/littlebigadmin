module LittleBigAdmin
  class ApplicationController < ActionController::Base

    before_filter :reload_objects

    def reload_objects
      LittleBigAdmin.load_all_objects unless Rails.application.config.cache_classes
    end
  end
end
