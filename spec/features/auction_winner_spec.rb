require 'spec_helper'
require 'delorean'
require 'pp'

describe 'get_winning_user and get_winning_bid functionality : ' do

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
      @product.get_winning_bid.should == nil
      @product.get_winning_user.should == nil
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

      @product.get_winning_user.should == @user1
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

      @product.get_winning_user.should == @user2
    end
  end
end

