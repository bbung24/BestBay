class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :product_id
      t.integer :user_id
      t.integer :price

      t.timestamps
    end
  end
end
