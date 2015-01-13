LittleBigAdmin.model :business do

  menu "Business", section: "Models"

  show do
    panel "Details" do
      field :name
      field :funnel_stage
    end
  end

  index do
    linked_column :id
    linked_column :name
    column :funnel_stage
    column :created_at
    default_actions
  end

  form do |f|
    panel "Details" do
      f.row do
        f.text_field :name
        f.select :funnel_stage, collection: (0..5)
      end
    end

  end
end
