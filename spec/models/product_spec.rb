require 'spec_helper'
require 'delorean'

describe Product do

  describe "Product specific tests" do
    before { @product = Product.new(title: "Shoe", condition: "new", detail:"A brand new shoe never used.", price: 25, deadline:DateTime.current + 2.days, current_price:25, keywords:"shoe") }

    subject { @product }

    it { should respond_to(:title) }
    it { should respond_to(:condition) }
    it { should respond_to(:detail) }
    it { should respond_to(:price) }
    it { should respond_to(:deadline) }
    it { should respond_to(:current_price) }
    it { should respond_to(:keywords) }
    it { should respond_to(:product_picture)}
    it {should respond_to (:uploaded_picture=)}
    it { should respond_to(:watch_list_relationships)}
    it { should respond_to(:user)}
    it { should respond_to(:is_active?)}
    it { should respond_to(:is_removable?) }

    it { should be_valid }

    describe "when title is not present" do
      before { @product.title = " " }
      it { should_not be_valid }
    end

    describe "when condition is not present" do
      before { @product.condition = " " }
      it { should_not be_valid }
    end

    describe "when detail is not present" do
      before { @product.detail = " " }
      it { should_not be_valid }
    end

    describe "when price is not present" do
      before { @product.price = " " }
      it { should_not be_valid }
    end

    describe "when deadline is not present" do
      before { @product.deadline = " " }
      it { should_not be_valid }
    end

    describe "when price is less than 0" do
      before { @product.price = -10 }
      it { should_not be_valid }
    end

    describe "When user adds product to watch list" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        @product.save
        user.save
        user.add_to_watch_list!(@product)
      end

      it { should be_watching(user) }
      its(:watch_list_users) { should include(user) }

      describe "And when user removes product from watch list" do
        before { user.remove_from_watch_list!(@product) }

        it { should_not be_watching(user) }
        its(:watch_list_users) { should_not include(user) }
      end

    end


    it "with deadline in future should be active" do
      @product.deadline = DateTime.current + 1.minute
      expect(@product.is_active?).to be_true
    end

    it "with deadline in past should not be active" do
      @product.deadline = DateTime.current - 1.second
      expect(@product.is_active?).to be_false
    end

    # Product is removable in following cases
    #     * when it does not have any bids
    #     * when bids prices are less than list price of the product
    #       (This is already covered as we are not allowing a bid lesser than product price)
    #
    let(:product) { FactoryGirl.create(:product) }
    let (:bid) { product.bids.new }
    it "should not be removable" do
      bid.user=User.last
      bid.price=product.price + 1000
      bid.save
      expect(product.is_removable?).to be_false
    end

    it "should be removable" do
      expect(@product.is_removable?).to be_true
    end

    context "with auction deadline in" do

      it "past should be invalid" do
        @product.deadline = DateTime.current - 10.seconds
        expect(@product).not_to be_valid
      end

      it "future (less than 1 minute) should be invalid" do
        @product.deadline = DateTime.current + 0.minutes
        expect(@product).not_to be_valid
      end

      it "future (at least 12 hours) should be valid" do
        @product.deadline = DateTime.current + 12.hours + 1.minute
        expect(@product).to be_valid
      end

    end
  end

  describe "checking owning_user_can_be_rated function" do
    let(:product1) { FactoryGirl.create(:product) }
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    it "should give access only to winning users" do
      product1.owning_user_can_be_rated(user1).should == false
      product1.owning_user_can_be_rated(user2).should == false
      product1.owning_user_can_be_rated(product1.user).should == false

      @bid = Bid.new(product_id: product1.id,
                     user_id: user1.id,
                     price: 26)
      @bid.save!

      product1.owning_user_can_be_rated(user1).should == false
      product1.owning_user_can_be_rated(user2).should == false
      product1.owning_user_can_be_rated(product1.user).should == false

      Delorean.time_travel_to(product1.deadline)  do
        product1.close_auction

        product1.owning_user_can_be_rated(user1).should == true
        product1.owning_user_can_be_rated(user2).should == false
        product1.owning_user_can_be_rated(product1.user).should == false
      end
    end
  end
  describe "Prohibited Item" do


  let(:product1) { FactoryGirl.build(:product) }
  let(:product2) { FactoryGirl.create(:product) }
  let!(:bad1) {FactoryGirl.create(:bad_keyword) }
  let!(:bad2) {FactoryGirl.create(:bad_keyword) }

  describe "should not be valid with bad words in" do
    it "title" do
      product1.title = bad1.keyword;
      expect(product1).not_to be_valid
    end
    it "keywords" do
      product1.keywords = bad1.keyword;

      expect(product1).not_to be_valid
    end
    it "description" do
      product1.detail = bad1.keyword;
      expect(product1).not_to be_valid
    end

  end

    # Create bad keywords
    # Create an item with bad keywords and it should not be saved
    # Create and item with good keywords and it should be saved
    # Update an item with bad keywords and it should not be saved

  end
end