class ProductPicture < ActiveRecord::Base
  belongs_to :product, class_name: "Product"
  attr_accessible :content_type, :image_data, :name
  validates_presence_of :name, :content_type, :image_data
end