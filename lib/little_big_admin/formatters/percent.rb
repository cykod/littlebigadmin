module LittleBigAdmin
  module Formatters
    class Percent
      extend ActionView::Helpers::NumberHelper

      def self.format(value,options={})
        number_to_percentage(value, { precision: 1 }.merge(options))
      end
    end
  end
end
