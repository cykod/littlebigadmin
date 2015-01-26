module LittleBigAdmin
  module Formatters
    class Numeric
      extend ActionView::Helpers::NumberHelper

      def self.format(value,options={})
        if value.present? && value.ceil != value
          number_with_precision(value, { precision: 2, delimiter: "," }.merge(options))
        else
          number_with_delimiter(value, options)
        end
      end
    end
  end
end
