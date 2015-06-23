LittleBigAdmin.graph :recent_businesses do
  
  #cache_for 10.minutes

  type :line

  name "Recent Business Joins"

  x_axis 'Date', position: 'outer-center'
  y_axis "Businesses Created"

  columns do
    businesses = Business.where("created_at > ?",6.months.ago.at_beginning_of_month)
              .group("date_trunc( 'day', created_at)")

    data = businesses.count.to_a
            
    {
      'x' => data.map { |b| b[0] },
      'businesses' => data.map { |b| b[1] }
    }
  end

end
