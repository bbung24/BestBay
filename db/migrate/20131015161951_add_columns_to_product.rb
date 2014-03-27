class AddColumnsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :title, :string
    add_column :products, :condition, :string
    add_column :products, :detail, :string
    add_column :products, :price, :integer

  end
end
