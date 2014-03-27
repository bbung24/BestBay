class AddColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :keywords, :string
    add_column :products, :deadline, :datetime
    add_column :products, :current_price, :integer
  end
end
