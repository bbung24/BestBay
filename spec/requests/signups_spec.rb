require 'spec_helper'

describe "Signups" do

  after(:each) do
    User.delete_all
  end
  context "navigation is working properly" do
    before {visit root_path}
    it "home page should have a register button" do
      expect(page).to have_button("Register")
    end
    it "Register button lands on sign up page" do
      click_button("Register")
      expect(page).to have_content("Sign up")
    end
  end
  let!(:user) { FactoryGirl.build(:user)}
  it "should be successful with valid first_name, last_name, email and password" do
    sign_up_with(user.first_name, user.last_name, user.email, user.password, user.password_confirmation)
    #save_and_open_page
    expect(page).to have_content(user.email)
  end

  context "should not create user" do
    before(:each) do
      visit '/users/sign_up?'
    end
    after(:each) do
      User.delete_all
    end
    let!(:user1) { FactoryGirl.create(:user)}
    it "with duplicate email address" do
      sign_up_with(user1.first_name, user1.last_name, user1.email, user1.password, user1.password_confirmation)
      #save_and_open_page
      expect(page).to have_content("Email has already been taken")
    end

    it "with blank email address" do
      user.email=""
      sign_up_with(user.first_name, user.last_name, user.email, user.password, user.password_confirmation)
      #save_and_open_page
      expect(page).to have_content("Email can't be blank")
    end

    it "with blank first name" do
      user.first_name=""
      sign_up_with(user.first_name, user.last_name, user.email, user.password, user.password_confirmation)
      #save_and_open_page
      expect(page).to have_content("First name can't be blank")
    end

    it "with blank last name" do
      user.last_name=""
      sign_up_with(user.first_name, user.last_name, user.email, user.password, user.password_confirmation)
      #save_and_open_page
      expect(page).to have_content("Last name can't be blank")
    end

    context "with invalid email format" do
      it "not containing Top Level Domain" do
        user.email="test1@test"
        sign_up_with(user.first_name, user.last_name, user.email, user.password, user.password_confirmation)
        expect(page).to have_content("Email is invalid")
      end

      it "containing a simple string" do
        user.email="simple"
        sign_up_with(user.first_name, user.last_name, user.email, user.password, user.password_confirmation)
        expect(page).to have_content("Email is invalid")
      end
    end

    it "with different password and password confirmation" do
      user.password_confirmation="confirmation"
      sign_up_with(user.first_name, user.last_name, user.email, user.password, user.password_confirmation)
      expect(page).to have_content("Password doesn't match confirmation")
    end

    it "with short password" do
      user.password="hello"
      user.password_confirmation="hello"
      sign_up_with(user.first_name, user.last_name, user.email, user.password, user.password_confirmation)
      expect(page).to have_content("Password is too short")
    end
  end
end
