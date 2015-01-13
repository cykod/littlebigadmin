module LittleBigAdmin
  module Formatters
    class Date
      def self.format(value,options={})
        if value.class.to_s == "Date"
          value.to_time.to_s(options[:format] || :little_big_admin_date)
        else
          value.to_s(options[:format] || :little_big_admin_time)
        end
      end
    end
  end
end
