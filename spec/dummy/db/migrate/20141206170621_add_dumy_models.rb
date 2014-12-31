class AddDumyModels < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :funnel_stage
      t.datetime :created_at
    end

    create_table :users do |t|
      t.integer :business_id
      t.string :first_name
      t.string :last_name
      t.string :position
      t.datetime :created_at
    end

    create_table :orders do |t|
      t.integer :business_id
      t.integer :user_id
      t.float :total
    end

    create_table :order_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.float :unit_price
      t.integer :quantity
      t.float :subtotal
    end

    create_table :products do |t|
      t.string :name
      t.attachment :picture
      t.text :description
      t.float :price
    end

  end


end
