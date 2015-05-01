class LittleBigAdmin::Page < LittleBigAdmin::Base

  def self.page_settings
    setting :show

  end

  def self.menu_settings

    setting :name do
      @name
    end

    setting :menu do
      [ @name.to_s.titleize, { priority: 0 } ]
    end

    setting :title do
      @name.to_s.titleize
    end

    setting :permit, :root

  end


  menu_settings
  page_settings
end
