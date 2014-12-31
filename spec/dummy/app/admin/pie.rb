LittleBigAdmin.graph :funnel_breakdown do

  cache_for 30.minutes

  type :pie

  columns do
    Business.group("funnel_stage").count.to_a
  end
end
