LittleBigAdmin.graph :recent_businesses do
  
  cache_for 10.minutes

  type :line

  x_axis 'Date', position: 'outer-center'
  y_axis "Businesses Created"

  filter :search, input: :text

  columns do |search|
    businesses = Business.where("created_at > ?",6.months.ago.at_start_of_month)
              .group("date_trunc( 'month', created_at)")

    if search.present?
      businesses = businesses.where("name like ?","%#{search}%")
    end
    
    data = businesses.count.to_a
            
    {
      'x' => data.map { |b| b[0] },
      'businesses' => data.map { |b| b[1] }
    }
  end

end
