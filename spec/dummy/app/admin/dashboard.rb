# /admin/pages/dashboard
# /admin/graphs/funnel_breakdown?search=7
LittleBigAdmin.page :dashboard do

  show do
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
