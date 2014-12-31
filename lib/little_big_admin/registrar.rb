class LittleBigAdmin::Registrar

  def self.register(type, name, options = {}, &block)
    helper_klass = helper_class(type)
    instance = helper_klass.new(name, options, &block)
    LittleBigAdmin.objects ||= {}
    LittleBigAdmin.objects[type.to_sym] ||= {}
    LittleBigAdmin.objects[type.to_sym][name.to_sym] = instance
  end

  def self.helper_class(type)
    "LittleBigAdmin::#{type.to_s.classify}".constantize
  end
end
