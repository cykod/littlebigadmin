module LittleBigAdmin
  module Formatters
    class Numeric
      extend ActionView::Helpers::NumberHelper

      def self.format(value,options={})
        number_with_delimiter(value, options)
      end
    end
  end
end
