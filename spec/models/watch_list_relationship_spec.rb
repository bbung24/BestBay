require 'spec_helper'

describe WatchListRelationship do
  let(:product) { FactoryGirl.create(:product) }
  let(:user) { FactoryGirl.create(:user) }
  let(:watch_list_relationship) { user.watch_list_relationships.build(product_id: product.id) }

  subject { watch_list_relationship }

  it { should be_valid }

  describe "user/product methods" do
    it { should respond_to(:product) }
    it { should respond_to(:user) }
    its(:user) { should eq user }
    its(:product) { should eq product }
  end

  describe "when user id is not present" do
    before { watch_list_relationship.user_id = nil }
    it { should_not be_valid }
  end

  describe "when product id is not present" do
    before { watch_list_relationship.product_id = nil }
    it { should_not be_valid }
  end

end
