class CreateWatchListRelationships < ActiveRecord::Migration
  def change
    create_table :watch_list_relationships do |t|
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end
    add_index :watch_list_relationships, :user_id
    add_index :watch_list_relationships, :product_id
    add_index :watch_list_relationships, [:user_id, :product_id], :unique => true
  end
end
