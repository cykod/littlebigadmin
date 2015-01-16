# /admin/pages/dashboard
# /admin/graphs/funnel_breakdown?search=7
LittleBigAdmin.page :dashboard do

  menu false

  show do
    h3 "Metrics"
    metrics do |m|
      m.stat("Total Widgets", 50352, subtitle: "Last Month", format: :numeric, description: "How many widgets we dingbatted", percent: 0.5)
      m.stat("New Customers", 23545, subtitle: "Last Month", format: :numeric, description: "How many customers widgeted", percent: -4.5)
      m.stat("Total Sales", 54334, subtitle: "YTD", format: :currency, description: "How much profits we widgetted", ) 
      m.stat("Customers", 54334, subtitle: "Overall", format: :numeric, description: "Total people buying widgets") 
    end

    h3 "Graphs"

    grid do 
      panel "Something A", size: 3 do
        graph :funnel_breakdown
        graph :recent_businesses
      end

      panel "Something B" do
        render partial: "/admin/dashboard/testerama"
      end
    end
  end
end
