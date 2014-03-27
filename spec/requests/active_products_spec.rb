require 'spec_helper'

describe "ActiveProducts" do
  before do
    load "#{Rails.root}/db/seeds.rb"
  end

  after(:all) do
    Product.delete_all
    User.delete_all
  end
  describe "Navigation Menu" do
    it "contains Active Link" do
      visit '/'
      expect(page).to have_content("My Products")
    end
  end
  describe "User Active Product" do
  end
end