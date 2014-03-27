require 'spec_helper'

describe Bid do
  it 'can be created' do
    lambda {
      FactoryGirl.create(:bid)
    }.should change(Bid, :count).by(1)
  end

  it "is not valid without a price" do
    subject.should_not be_valid
    subject.errors[:price].should_not be_empty
  end

  it "is not valid without a user_id" do
    subject.should_not be_valid
    subject.errors[:user_id].should_not be_empty
  end

  it "is not valid without a product_id" do
    subject.should_not be_valid
    subject.errors[:product_id].should_not be_empty
  end

  context "is not valid" do
    [:price, :user_id, :product_id].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end

  context "associations --" do
    it 'belongs to a user' do
      subject.should respond_to(:user)
    end

    it 'belongs to a product' do
      subject.should respond_to(:product)
    end
  end
end
