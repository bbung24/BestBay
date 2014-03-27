require 'spec_helper'

describe "PostItems" do
  before do
    load "#{Rails.root}/db/seeds.rb"
    visit '/users/sign_in?'
    within ("#signin_form") do
      fill_in "Email", with: 'iyong@example.com'
      fill_in "Password", with: 'foooobar'
    end
    click_button "Sign in"
    visit '/products/new?'
  end

  after(:all) do
    Product.delete_all
    User.delete_all
  end

  it "should have a post_item page" do
    expect(page).to have_content('Enter information about your new item')
  end

  describe "should create a product with valid data" do

    before do
      within ("#post_item_form") do
        fill_in "Title", with: 'A brand new shoe of size 6'
        fill_in "Keywords", with: 'shoe'
        fill_in "Condition", with: 'new'
        fill_in "Detail", with: 'It is a brand new Nike shoe of size 6 for ladies. Color is pink. You will definitely love it!'
        fill_in "Price", with: '25'
        select '2014', from: 'product_deadline_1i'
        select 'October', from: 'product_deadline_2i'
        select '1', from: 'product_deadline_3i'
        select '12', from: 'product_deadline_4i'
        select '10', from: 'product_deadline_5i'
      end
      click_button "Post Item"
    end

    subject{page}
  end


end
