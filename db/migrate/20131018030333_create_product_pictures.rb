class CreateProductPictures < ActiveRecord::Migration
  def change
    create_table :product_pictures do |t|
      t.string :name
      t.string :content_type
      t.binary :image_data, :limit => 1.megabyte

      t.timestamps
    end
  end
end
