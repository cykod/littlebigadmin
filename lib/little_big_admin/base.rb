class LittleBigAdmin::Base

  class_attribute :setting_configs
  class_attribute :list_setting_configs

  attr_accessor :locked

  def initialize(name, options = {}, &block)
    @name = name.to_sym
    @options = options

    @settings = {}
    @list_settings = {}

    instantiate_default_settings
    
    instance_eval &block if block

    instantiate_default_list_settings

    self.locked = true if block
  end


  def process_args(args,&block)
    options = args.last.is_a?(Hash) ? args.pop : {}

    block = if block
      block.to_proc
    elsif args[0].is_a?(Proc)
      args.shift
    else
      nil
    end

    [ options, block ]
  end

  def self.setting(attribute, default_value = nil, &block)
    self.setting_configs ||= {}

    self.setting_configs[attribute] = if block_given?
                                        block.to_proc
                                      else
                                        default_value
                                      end

    define_method attribute do |*args, &block|
      if locked
        return @settings[attribute] && @settings[attribute][:args][0]
      end
      options, block = process_args(args, &block)
      existing = @settings[attribute] || { options: {} }
      @settings[attribute]  = { args: args, 
                                options: existing[:options].merge(options), 
                                block: block || existing[:block] }
    end

    define_accessor_methods(attribute)
  end


  def self.define_accessor_methods(attribute)
    define_method "#{attribute}_value" do 
      @settings[attribute][:args][0]
    end

    define_method "#{attribute}_args" do
      @settings[attribute][:args]
    end

    define_method "#{attribute}_options" do 
      @settings[attribute][:options]
    end

    define_method "#{attribute}_block" do 
      @settings[attribute][:block]
    end
  end

  def self.list_setting(attribute, &block)
    self.list_setting_configs ||= {}
    self.list_setting_configs[attribute] = block || true

    define_method attribute do |*args|
      @list_settings[attribute] ||= []
      @list_settings[attribute].push(args)
    end

    define_method "#{attribute}_settings" do
      @list_settings[attribute] || []
    end

  end

  def permitted?(permission)
    permission = permission.to_sym
    perms = LittleBigAdmin.config.permissions

    item_permissions = perms.index(self.permit_value)

    if item_permissions.is_a?(Array)
      perms.include?(permission)
    else
      perms.index(permission).present? && perms.index(permission) <= item_permissions
    end

  end

  private

  def instantiate_default_settings
    setting_configs.each do |setting, value|
      value = instance_eval &value if value.is_a?(Proc)
      self.send(setting,*value)
    end

  end

  def instantiate_default_list_settings
    return unless list_setting_configs
    list_setting_configs.each do |setting, settings_array|
      if settings_array != true && !@list_settings[setting]
        instance_eval(&settings_array).each do |setting_entry|
          self.send(setting, *setting_entry)
        end
      end
    end
  end




end
