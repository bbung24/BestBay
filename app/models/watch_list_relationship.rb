class WatchListRelationship < ActiveRecord::Base
  attr_accessible :product_id, :user_id
  belongs_to :user, class_name: "User"
  belongs_to :product, class_name: "Product"
  validates :product_id, presence: true
  validates :user_id, presence: true
end
