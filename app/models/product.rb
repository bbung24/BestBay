class Product < ActiveRecord::Base
  belongs_to :user
  has_one :product_picture, foreign_key: "product_id", dependent: :destroy
  has_many :watch_list_relationships, foreign_key: "product_id", dependent: :destroy
  has_many :watch_list_users, through: :watch_list_relationships, source: :user
  has_many :bids, foreign_key: "product_id", dependent: :destroy
  attr_accessible :title, :condition, :detail, :price, :keywords, :deadline, :current_price, :uploaded_picture, :picture
  validates :title, presence: true
  validates :condition, presence: true
  validates :detail, presence: true
  validates :price, presence: true
  validates :deadline, presence: true
  validates_numericality_of :price, :greater_than => 0
  validate :is_auction_deadline_in_future?, if: "deadline != nil"
  validate :does_not_contain_bad_words
  after_initialize :init

  def init
    self.current_price ||= self.price
  end

  def is_auction_deadline_in_future?
    if self.deadline < DateTime.current + 1.minute
      errors.add(:deadline, "should be in future (at least 1 minute)")
    end
  end

  def  does_not_contain_bad_words
    bad_keywords = BadKeyword.all

    bad_keywords.each do |bad_keyword|
      # TODO: There might be some bigger words that are legal but their subset is illegal--take care of those
      if self.title.index(bad_keyword.keyword) != nil
         errors.add(:title, "contains a bad word:"+bad_keyword.keyword)
         return false
      end
      if self.keywords.index(bad_keyword.keyword) != nil
        errors.add(:keywords, "contains a bad word:"+bad_keyword.keyword)
        return false
      end
      if self.detail.index(bad_keyword.keyword) != nil
        errors.add(:detail, "contains a bad word:"+bad_keyword.keyword)
        return false
      end
    end
    return true
  end

  def uploaded_picture=(picture_field)
    @picture = ProductPicture.new
    @picture.name         = base_part_of(picture_field.original_filename)
    @picture.content_type = picture_field.content_type.chomp
    @picture.image_data   = picture_field.read
  end

  def save
    is_product_saved = super
    if (!self.new_record? and @picture != nil)
      @picture.product = self
      @picture.save
    end
    return is_product_saved
  end

  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end

  def self.search(search)
    if search
      where('deadline > ? AND (upper(title) LIKE ? OR upper(keywords) LIKE ?)', DateTime.current, "%#{search.upcase}%", "%#{search.upcase}%")
    else
      where("deadline > ?" ,DateTime.current)
    end
  end

  def watching?(user)
    watch_list_relationships.find_by_user_id(user.id)
  end

  # Product is Active when its deadline is not passed
  # Product is not Active when its deadline is passed
  #
  def is_active?
    self.deadline > DateTime.current
  end

  # Product is removable in following cases
  #     * when it does not have any bids
  #     * when bids prices are less than list price of the product
  #       (This is already covered as we are not allowing a bid lesser than product price)
  #
  def is_removable?
    if self.bids.count > 0
      false
    else
      true
    end
  end

  def close_auction
    if self.bids != nil and self.bids != []
      self.bids.each do |bid|
        bid.update_attribute(:bid_status, 'lost')
      end
      lastBid = self.bids.last
      lastBid.update_attribute(:bid_status, 'won')

      self.watch_list_users.each do |user|
        Notifier.bid_time_ended(self, user).deliver
      end

      Notifier.won_the_bid(self, lastBid.user).deliver
    end
  end

  def get_winning_bid
    if !self.is_active?
      if self.bids != nil and self.bids != []
        return self.bids.last
      end
    end
  end

  def get_winning_user
    winning_bid = get_winning_bid
    if winning_bid != nil
      return winning_bid.user
    end
  end

  def owning_user_can_be_rated(user)
    if self.user != user and !self.is_active?
      return user == self.get_winning_bid.user
    end
    return false
  end

end
