class LittleBigAdmin::Config 

  def initialize
    @settings = {}
  end

  def run(&block)
    yield self
  end

  def self.defaults 
    {
      title: "Admin Panel",
      current_user: -> { current_user },
      authorize: ->(type, model, action_name) { current_user.present? },
      login_path: -> { },
      logout_path: -> { },
      date_format: "%-m/%-d/%Y",
      time_format: "%-m/%-d/%Y %l:%M%P"
    }
    
  end

  def self.setup_attributes
    defaults.each do |attribute, default|
      define_method attribute do
        @settings[attribute] || default
      end

      define_method "#{attribute}=" do |val|
        @settings[attribute] = val
      end
    end
  end

  setup_attributes

  def load_paths
    @load_paths ||= [ File.expand_path('app/admin', Rails.root || File.dirname(__FILE__)) ]
  end

end
