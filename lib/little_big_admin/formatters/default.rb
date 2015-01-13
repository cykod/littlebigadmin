module LittleBigAdmin
  module Formatters
    class Default

      def self.format(value,options={})
        max_length = options[:length] || 120
        separator = options[:separator] || " "
        value.to_s.truncate(max_length, separator: separator)
      end
    end
  end
end
