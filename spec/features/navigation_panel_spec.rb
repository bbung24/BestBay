require 'spec_helper'

describe "NavigationPanel" do

  subject { page }

  describe "Check all Paths" do
    before(:each) do
      visit root_path
    end

    context 'Before Sign In.' do

      describe "Checking : ", :js => true do
        it "Homepage link" do
          page.find("td#Homepage").click()
          current_path.should == root_path
        end
        it "All Bids link" do
          page.find("td#MyBids").click()
          current_path.should == new_user_session_path
        end
        it "View List link" do
          page.find("td#ViewList").click()
          current_path.should == new_user_session_path
        end
        it "Sell A Product link" do
          page.find("td#SellProduct").click()
          current_path.should == new_user_session_path
        end
        it "My Product link" do
          page.find("td#MyProducts").click()
          current_path.should == new_user_session_path
        end
      end
    end

    context 'After Sign In.' do
      before(:each) do
        visit '/users/sign_in?'
        within ("#register_form") do
          fill_in "First name", with: 'inho'
          fill_in "Last name", with: 'yong'
          fill_in "Email", with: 'iyong@example.com'
          fill_in "Password", with: 'foooobar'
          fill_in "Password confirmation", with: 'foooobar'
        end
        click_button "Sign up"
      end

      describe "Checking : ", :js => true do
        it "Homepage link" do
          page.find("td#Homepage").click()
          current_path.should == root_path
        end
        it "All Bids link" do
          page.find("td#MyBids").click()
          current_path.should == user_my_bids_path
        end

        it "View List link" do
          page.find("td#ViewList").click()
          current_path.should == watch_list_path
        end
        it "Sell A Product link" do
          page.find("td#SellProduct").click()
          current_path.should == new_product_path
        end
        it "Active Items link" do
          page.find("td#MyProducts").click()
          current_path.should == user_active_products_path
        end
      end
    end
  end
end