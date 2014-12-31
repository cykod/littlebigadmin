class LittleBigAdmin::Page < LittleBigAdmin::Base

  def self.page_settings
    setting :show
  end

  page_settings
end
