require 'spec_helper'
require 'delorean'
require 'pp'

describe 'close_auction functionality : ' do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @product = FactoryGirl.create(:product)
  end

  after(:each) do
    Product.delete_all
    User.delete_all
    Bid.delete_all
    ActionMailer::Base.deliveries = []
  end

  it 'there was no bidder so nobody should win' do

    Delorean.time_travel_to(@product.deadline)  do
      @product.close_auction

      @winningBid = @product.get_winning_bid
      @winningBid.should == nil

      ActionMailer::Base.deliveries.empty?.should == true
    end
  end



  it 'user1 should win the bid if he is only bidder' do
    @bid = Bid.new(product_id: @product.id,
                   user_id: @user1.id,
                   price: 26)
    @bid.save!

    Delorean.time_travel_to(@product.deadline)  do
      @product.close_auction

      @winningBid = @product.get_winning_bid
      @winningBid.bid_status.should == 'won'
      @winningBid.user_id.should == @bid.user_id
      @winningBid.price.should == @bid.price

      ActionMailer::Base.deliveries.empty?.should == false
      mail = ActionMailer::Base.deliveries[0]
      mail.to.should ==  [@user1.email]
      mail.subject.should ==  "Bid Winner for " + @product.title
    end
  end

  it 'user2 should win the bid if he outbids user1' do
    @bid1 = Bid.new(product_id: @product.id,
                   user_id: @user1.id,
                   price: 26)
    @bid1.save!
    @bid2 = Bid.new(product_id: @product.id,
                   user_id: @user2.id,
                   price: 27)
    @bid2.save!

    Delorean.time_travel_to(@product.deadline)  do
      @product.close_auction

      @winningBid = @product.get_winning_bid
      @winningBid.bid_status.should == 'won'
      @winningBid.user_id.should == @bid2.user_id
      @winningBid.price.should == @bid2.price

      ActionMailer::Base.deliveries.empty?.should == false
      mail = ActionMailer::Base.deliveries[0]
      mail.to.should ==  [@user2.email]
      mail.subject.should ==  "Bid Winner for " + @product.title
    end
  end

  it 'all users that are on the watchlist should get emails' do
    @user3 = FactoryGirl.create(:user)
    @user3.add_to_watch_list!(@product)
    @user4 = FactoryGirl.create(:user)
    @user4.add_to_watch_list!(@product)
    @user1.add_to_watch_list!(@product)
    @user2.add_to_watch_list!(@product)

    @bid1 = Bid.new(product_id: @product.id,
                    user_id: @user1.id,
                    price: 26)
    @bid1.save!
    @bid2 = Bid.new(product_id: @product.id,
                    user_id: @user2.id,
                    price: 27)
    @bid2.save!

    Delorean.time_travel_to(@product.deadline)  do
      @product.close_auction

      @winningBid = @product.get_winning_bid
      @winningBid.bid_status.should == 'won'
      @winningBid.user_id.should == @bid2.user_id
      @winningBid.price.should == @bid2.price

      ActionMailer::Base.deliveries.empty?.should == false
      counter = 0
      @product.watch_list_users.each do |user|
        mail = ActionMailer::Base.deliveries[counter]
        mail.to.should ==  [user.email]
        mail.subject.should ==  "Bid time ended for " + @product.title
        counter += 1
      end

      mail = ActionMailer::Base.deliveries[counter]
      mail.to.should ==  [@user2.email]
      mail.subject.should ==  "Bid Winner for " + @product.title

    end
  end


end

