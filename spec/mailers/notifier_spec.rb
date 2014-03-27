require "spec_helper"

describe Notifier do
  describe "bid winner announced" do
    let(:product) { FactoryGirl.create(:product) }
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { Notifier.won_the_bid(product, user) }

    it "renders correct Subject" do
      mail.subject.should eq("Bid Winner for #{product.title}")
    end

    it "renders correct To address" do
      mail.to.should eq([user.email])
    end

    it "renders correct from address" do
      mail.from.should eq(["noreply@mighty-river-6835.herokuapp.com"])
    end

    it "renders the body as desired" do
      mail.body.encoded.should match("Dear #{user.first_name} #{user.last_name},")
      mail.body.encoded.should match(product_url(product))
      mail.body.encoded.should match("Congratulations for winning bid for the product #{product.title}")
    end
  end

  describe "bid_time_ended" do
    let(:product) { FactoryGirl.create(:product) }
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { Notifier.bid_time_ended(product, user) }

    it "renders correct Subject" do
      mail.subject.should eq("Bid time ended for #{product.title}")
    end

    it "renders correct To address" do
      mail.to.should eq([user.email])
    end

    it "renders correct from address" do
      mail.from.should eq(["noreply@mighty-river-6835.herokuapp.com"])
    end

    it "renders the body as desired" do
      mail.body.encoded.should match("Dear #{user.first_name} #{user.last_name},")
      mail.body.encoded.should match(product_url(product))
      mail.body.encoded.should match("Bid time is ended for product #{product.title}")
    end
  end

  describe "new_bid_added" do
    let(:product) { FactoryGirl.create(:product) }
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { Notifier.new_bid_added(product, user) }

    it "renders correct Subject" do
      mail.subject.should eq("New bid on product #{product.title}")
    end

    it "renders correct To address" do
      mail.to.should eq([user.email])
    end

    it "renders correct from address" do
      mail.from.should eq(["noreply@mighty-river-6835.herokuapp.com"])
    end

    it "renders the body as desired" do
      mail.body.encoded.should match("Dear #{user.first_name} #{user.last_name},")
      mail.body.encoded.should match(product_url(product))
      mail.body.encoded.should match("A new bid is added to #{product.title}")
    end
  end

  describe "product_information_changed" do
    let(:product) { FactoryGirl.create(:product) }
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { Notifier.product_information_changed(product, user) }

    it "renders correct Subject" do
      mail.subject.should eq("Product information changed for #{product.title}")
    end

    it "renders correct To address" do
      mail.to.should eq([user.email])
    end

    it "renders correct from address" do
      mail.from.should eq(["noreply@mighty-river-6835.herokuapp.com"])
    end

    it "renders the body as desired" do
      mail.body.encoded.should match("Dear #{user.first_name} #{user.last_name},")
      mail.body.encoded.should match("Product description is changed for #{product.title}")
      mail.body.encoded.should match(product_url(product))
    end

  end

  describe "product_retracted" do
    let(:product) { FactoryGirl.create(:product) }
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { Notifier.product_retracted(product,user) }

    it "renders correct Subject" do
      mail.subject.should eq("Product Retracted: #{product.title}")
    end

    it "renders correct To address" do
      mail.to.should eq([user.email])
    end

    it "renders correct from address" do
      mail.from.should eq(["noreply@mighty-river-6835.herokuapp.com"])
    end

    it "renders the body as desired" do
      mail.body.encoded.should match("Dear #{user.first_name} #{user.last_name},")
      mail.body.encoded.should match("Product with title '#{product.title}' is retracted by the product owner")
    end
  end

end
