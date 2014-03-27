class CreateBadKeywords < ActiveRecord::Migration
  def change
    create_table :bad_keywords do |t|
      t.string :keyword

      t.timestamps
    end
  end
end
