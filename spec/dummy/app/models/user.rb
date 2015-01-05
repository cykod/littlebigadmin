class User < ActiveRecord::Base
  belongs_to :business
  

  
  def name
    [ first_name, last_name ].compact.join(" ")
  end
end
