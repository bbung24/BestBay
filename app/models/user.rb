class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :products, dependent: :destroy
  has_many :watch_list_relationships, foreign_key: "user_id", dependent: :destroy
  has_many :watch_list_products, through: :watch_list_relationships, source: :product
  has_many :bids, foreign_key: "user_id", dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Rating User Property
  # User is ratable with rating dimension
  letsrate_rateable "rating"
  # User is the one who can rate
  letsrate_rater

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  # attr_accessible :title, :body
  validates_presence_of :first_name, :last_name
  def authenticate?
    return false
  end
  def get_active_products
    self.products.where("deadline > ?" ,DateTime.current)
  end
  def get_closed_products
    self.products.where("deadline <= ?" ,DateTime.current)
  end
  def in_watch_list?(product)
    watch_list_relationships.find_by_product_id(product.id)
  end

  def add_to_watch_list!(product)
    if not self.in_watch_list?(product)
      watch_list_relationships.create!(product_id: product.id)
    end
  end

  def remove_from_watch_list!(product)
    if self.in_watch_list?(product)
      watch_list_relationships.find_by_product_id(product.id).destroy
    end
  end

  def get_collapsed_bids
    all_collapsed_bids = []
    self.bids.each do |bid|
      alreadyAdded = false
      all_collapsed_bids.each do |old_bid|
        if old_bid.product_id == bid.product_id
          if old_bid.price > bid.price
            alreadyAdded = true
          else
            all_collapsed_bids = all_collapsed_bids - [old_bid]
          end
        end
      end
      if !alreadyAdded
        all_collapsed_bids.append(bid)
      end
    end
    return all_collapsed_bids
  end

  def get_bids_won
    won_bids = []
    self.get_collapsed_bids.each do |bid|
      if bid.bid_status == 'won'
        won_bids.append(bid)
      end
    end
    return won_bids
  end

  def get_bids_lost
    lost_bids = []
    self.get_collapsed_bids.each do |bid|
      if bid.bid_status == 'lost'
          lost_bids.append(bid)
      end
    end
    return lost_bids
  end

  def get_bids_open
    open_bids = []
    self.get_collapsed_bids.each do |bid|
      if bid.bid_status == 'open'
          open_bids.append(bid)
      end
    end
    return open_bids
  end

end