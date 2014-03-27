class ChangeDataTypeForProductsPrice < ActiveRecord::Migration
  def up
    change_table :products do |t|
      t.change :price, :integer
    end
  end

  def down
  end
end
