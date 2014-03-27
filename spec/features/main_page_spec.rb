require 'spec_helper'

describe "MainPage" do
  before do
    load "#{Rails.root}/db/seeds.rb"
  end

  after(:all) do
    Product.delete_all
    User.delete_all
  end

  subject { page }

  describe "List Products" do
    before(:each) do
      visit root_path
    end

    context 'Before Sign In' do

      describe "should have a main page" do
        it { should have_content('Best Bay') }
        it { should have_button('Sign In') }
        it { should have_button('Register') }
        it { should_not have_button('Sign Out') }
        it { should have_button('Search') }
        it { should_not have_content("Welcome back iyong@example.com")}
      end

      describe "should list categories" do
        it { should have_content("Item Name") }
        it { should have_content("Condition") }
        it { should have_content("Current Price") }
      end

      describe "should list products" do

        it { should have_content('iPhone 5s') }
        it { should have_content("New") }
        it { should have_content(800) }
        it { should have_content('View') }
        it { should_not have_content('Add to Watchlist') }
      end
    end

    context 'After Sign In' do
      before do
        visit 'users/sign_in?'
        within ("#signin_form") do
          fill_in "Email", with: 'iyong@example.com'
          fill_in "Password", with: 'foooobar'
        end
        click_button "Sign in"
      end

      describe "should have a logged-in main page" do
        it { should have_content('Best Bay') }
        it { should_not have_button('Sign In') }
        it { should_not have_button('Register') }
        it { should have_button('Sign Out') }
        it { should have_button('Search') }
        it { should have_content("Welcome back iyong@example.com")}
      end

      describe "should list categories" do
        it { should have_content("Item Name") }
        it { should have_content("Condition") }
        it { should have_content("Current Price") }
      end

      describe "should list products" do
        it { should have_content('iPhone 5s') }
        it { should have_content("New") }
        it { should have_content(800) }
        it { should have_content('View') }
        it { should have_content('Add to Watchlist') }
      end

      context 'search' do
        before do
          within ("#search_form") do
            fill_in "search", with: 'iPhone 5s'
          end
          click_button 'Search'
        end

        describe "should list only iPhone" do
          it { should have_content('iPhone 5s') }
          it { should have_content('New') }
          it { should have_content(800) }
          it { should have_content('View') }
          it { should have_content('Add to Watchlist') }
        end
      end
    end

    describe "pagination" do
      it { should have_selector('div.pagination') }

      it "should list each product" do
        Product.paginate(page: 1, per_page: 10).each do |product|
          expect(page).to have_content(product.title)
          expect(page).to have_content(product.condition)
          expect(page).to have_content(product.current_price)
        end
      end
    end
  end
end