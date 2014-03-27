require 'spec_helper'
require 'user'
require 'ruby-debug'

describe User do

  let (:user) { User.new(email: 'mudassarn@gmail.com', password: 'password', first_name: 'Mudassar', last_name: 'Nazar') }
  subject{user}

  it { should respond_to(:email)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:watch_list_relationships)}
  it { should respond_to(:add_to_watch_list!) }
  it { should respond_to(:remove_from_watch_list!) }
  it { should respond_to(:products)}
  it { should be_valid}

  describe "A user with blank email" do
      before {user.email = ""}
      it {should_not be_valid}
  end

  describe "A user with blank password" do
    before {user.password = ""}
    it{should_not be_valid}
  end

  describe "A user with blank name" do
    before {user.first_name = "" }
    it{should_not be_valid}
  end

  describe "A user with blank name" do
    before {user.last_name = "" }
    it{should_not be_valid}
  end

  describe "Saving User"  do
    it "changes the users count by 1" do
      expect{user.save}.to change{User.count}.by(1)
    end
  end

  describe "Adding product to watch list" do
    let(:product) { FactoryGirl.create(:product) }

    before do
      user.save
      user.add_to_watch_list!(product)
    end

    it { should be_in_watch_list(product) }
    its(:watch_list_products) { should include(product) }

    describe "And removing product from watch list" do
      before { user.remove_from_watch_list!(product) }

      it { should_not be_in_watch_list(product) }
      its(:watch_list_products) { should_not include(product) }
    end

  end

  describe "checking methods to return bids" do
    let(:product1) {FactoryGirl.create(:product)}
    let(:product2) {FactoryGirl.create(:product)}
    let(:product3) {FactoryGirl.create(:product)}
    let(:user1) {FactoryGirl.create(:user)}
    let(:user2) {FactoryGirl.create(:user)}

    it "user1 and and user2 both bid on products" do
      @bid1 = Bid.new(product_id: product1.id,
                     user_id: user1.id,
                     price: 26)
      @bid1.save
      @bid2 = Bid.new(product_id: product1.id,
                      user_id: user2.id,
                      price: 27)
      @bid2.save
      @bid3 = Bid.new(product_id: product1.id,
                      user_id: user1.id,
                      price: 28)
      @bid3.save
      @bid4 = Bid.new(product_id: product1.id,
                      user_id: user2.id,
                      price: 29)
      @bid4.save


      user1_openBids = user1.get_bids_open
      user1_lostBids = user1.get_bids_lost
      user1_wonBids = user1.get_bids_won

      user1_openBids.size.should == 1
      user1_openBids[0].should == @bid3
      user1_lostBids.size.should == 0
      user1_wonBids.size.should == 0

      user2_openBids = user2.get_bids_open
      user2_lostBids = user2.get_bids_lost
      user2_wonBids = user2.get_bids_won

      user2_openBids.size.should == 1
      user2_openBids[0].should == @bid4
      user2_lostBids.size.should == 0
      user2_wonBids.size.should == 0

      Delorean.time_travel_to(product1.deadline)  do
        product1.close_auction
        user1.reload
        user2.reload

        user1_openBids = user1.get_bids_open
        user1_lostBids = user1.get_bids_lost
        user1_wonBids = user1.get_bids_won

        user1_openBids.size.should == 0
        user1_lostBids.size.should == 1
        user1_lostBids[0].should == @bid3
        user1_wonBids.size.should == 0

        user2_openBids = user2.get_bids_open
        user2_lostBids = user2.get_bids_lost
        user2_wonBids = user2.get_bids_won

        user2_openBids.size.should == 0
        user2_lostBids.size.should == 0
        user2_wonBids.size.should == 1
        user2_wonBids[0].should == @bid4
      end
    end

    it "only user1 bids on the product" do
      @bid1 = Bid.new(product_id: product2.id,
                      user_id: user1.id,
                      price: 26)
      @bid1.save
      @bid2 = Bid.new(product_id: product2.id,
                      user_id: user1.id,
                      price: 27)
      @bid2.save


      user1_openBids = user1.get_bids_open
      user1_lostBids = user1.get_bids_lost
      user1_wonBids = user1.get_bids_won

      user1_openBids.size.should == 1
      user1_openBids[0].should == @bid2
      user1_lostBids.size.should == 0
      user1_wonBids.size.should == 0

      user2_openBids = user2.get_bids_open
      user2_lostBids = user2.get_bids_lost
      user2_wonBids = user2.get_bids_won

      user2_openBids.size.should == 0
      user2_lostBids.size.should == 0
      user2_wonBids.size.should == 0

      Delorean.time_travel_to(product2.deadline)  do
        product2.close_auction
        user1.reload
        user2.reload

        user1_openBids = user1.get_bids_open
        user1_lostBids = user1.get_bids_lost
        user1_wonBids = user1.get_bids_won

        user1_openBids.size.should == 0
        user1_lostBids.size.should == 0
        user1_wonBids.size.should == 1
        user1_wonBids[0].should == @bid2

        user2_openBids = user2.get_bids_open
        user2_lostBids = user2.get_bids_lost
        user2_wonBids = user2.get_bids_won

        user2_openBids.size.should == 0
        user2_lostBids.size.should == 0
        user2_wonBids.size.should == 0
      end
    end

    it "no user bids on the product" do

      user1_openBids = user1.get_bids_open
      user1_lostBids = user1.get_bids_lost
      user1_wonBids = user1.get_bids_won

      user1_openBids.size.should == 0
      user1_lostBids.size.should == 0
      user1_wonBids.size.should == 0

      user2_openBids = user2.get_bids_open
      user2_lostBids = user2.get_bids_lost
      user2_wonBids = user2.get_bids_won

      user2_openBids.size.should == 0
      user2_lostBids.size.should == 0
      user2_wonBids.size.should == 0

      Delorean.time_travel_to(product3.deadline)  do
        product3.close_auction
        user1.reload
        user2.reload

        user1_openBids = user1.get_bids_open
        user1_lostBids = user1.get_bids_lost
        user1_wonBids = user1.get_bids_won

        user1_openBids.size.should == 0
        user1_lostBids.size.should == 0
        user1_wonBids.size.should == 0

        user2_openBids = user2.get_bids_open
        user2_lostBids = user2.get_bids_lost
        user2_wonBids = user2.get_bids_won

        user2_openBids.size.should == 0
        user2_lostBids.size.should == 0
        user2_wonBids.size.should == 0
      end
    end

  end

end
