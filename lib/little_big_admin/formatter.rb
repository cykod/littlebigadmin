module LittleBigAdmin
  class Formatter
    def self.format(object, field, options = {})
      value = object.send(field)
      as ||= options[:as] || choose_format(value)

      if as == :none
        value
      else
        run(value, as, options)
      end
    end


    def self.choose_format(value)

      case value
      when ActiveRecord::Base
        :model
      when Date, Time, ActiveSupport::TimeWithZone
        :date
      else
        :default
      end
    end

    def self.run(value, as, options = {})
      fetch_class(as).format(value,options)
    end

    def self.fetch_class(as)
      "LittleBigAdmin::Formatters::#{as.to_s.camelcase}".constantize
    end
  end
end
