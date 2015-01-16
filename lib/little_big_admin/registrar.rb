class LittleBigAdmin::Registrar

  def self.register(type, name, options = {}, &block)
    helper_klass = helper_class(type)
    instance = helper_klass.new(name, options, &block)
    LittleBigAdmin.menu = nil
    LittleBigAdmin.objects ||= {}
    LittleBigAdmin.objects[type.to_sym] ||= {}
    LittleBigAdmin.objects[type.to_sym][name.to_sym] = instance
  end

  def self.get(type, name)
    LittleBigAdmin.objects[type.to_sym][name.to_sym]
  end

  def self.helper_class(type)
    "LittleBigAdmin::#{type.to_s.classify}".constantize
  end

  def self.menu
    return LittleBigAdmin.menu if LittleBigAdmin.menu
    all_objects = (LittleBigAdmin.objects[:page] || {}).values +
                  (LittleBigAdmin.objects[:model] || {}).values


    all_objects.reject! { |obj| obj.menu == false }
    
    sections = all_objects.group_by do |obj|
      obj.menu_options[:section] || nil
    end.to_a

    sections.sort_by! { |section| section[0].to_s }

    sections.each do |section|
      section[1].sort_by! { |item| item.menu_options[:priority] || 0 }
    end

  end
end
