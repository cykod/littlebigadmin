module LittleBigAdmin
  module Formatters
    class Currency
      extend ActionView::Helpers::NumberHelper

      def self.format(value,options={})
        number_to_currency(value, options)
      end
    end
  end
end
