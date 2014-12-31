# /admin/pages/dashboard
# /admin/graphs/funnel_breakdown?search=7
LittleBigAdmin.page :dashboard do

  show do
    panel do
      graph :recent_businesses
    end

    panel do
      graph :funnel_breakdown
    end
  end
end
