class Bid < ActiveRecord::Base
  attr_accessible :price, :product_id, :user_id, :bid_status
  validates_presence_of :user_id, :price, :product_id
  belongs_to :user, class_name: "User"
  belongs_to :product, class_name: "Product"
  delegate :first_name, :last_name, :to => :user, :prefix => true
end
