require 'spec_helper'

describe BidsController do

  describe "GET 'new'" do

    let (:product) { FactoryGirl.create(:product) }

    it "returns http success" do
      pending
      get 'new', product: :product.id2name
      response.should be_success
    end
  end

end
