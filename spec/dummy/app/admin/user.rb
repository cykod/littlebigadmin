# /admin/models/users
# /admin/models/users/lists/active
# /admin/models/users/actions/tester # POST
# /admin/models/users/7
# /admin/models/users/7/edit
# /admin/models/users/7/actions/frank # PATCH or GET

LittleBigAdmin.model :user do

  menu "User", section: "Models"

  # referred_to_as :user
  #plural_name :users

  # name ->(user) { user.name }

  #base_scope do
  #  User
  #end

  #new_model do
  #  User.new
  #end

  scope :all
  scope :active

  filter :name
  # filter :name, ->(q) { where(name: q) }, input: :text_field
  # filter :name, :like, input: :text_field

  index do
    linked_column :id, order: true
    linked_column :name
    linked_column :business #relationship are auto linked to other models and are preloaded automatically
    column :position

    column :created_at
    # default_actions
  end

  show do
    panel "Basic Info", size: 2 do
      grid do
        field :first_name, label: 'The First Name'
        field :last_name
      end

      grid do
        field :position, size: 2
        field :created_at
      end
    end

    panel "Details" do
      grid do 
        field :last_name
      end
    end
  end

  form do |f|
    panel "Stuffs" do
      grid do 
        # each row is divided between its fields
        f.text_field :first_name, size: 1
        f.text_field :last_name, size: 1
        #autocomplete_field :business, size: 2 # field with a change button, popup w/ autocomplete
      end
    end
  end

  collection_action :approve do |user_ids|
    # do something to the user ids
  end


end
