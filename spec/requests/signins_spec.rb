require 'spec_helper'

describe "Sign In" do

  context "navigation is working properly" do
    before {visit root_path}
    it "home page should have a register button" do
      expect(page).to have_button("Sign In")
    end
    it "Sign in button lands on sign in page" do
      click_button("Sign In")
      expect(page).to have_content("Sign in")
    end
  end

  let!(:user) { FactoryGirl.create(:user)}

  it "should be successful with valid user credentials" do
    sign_in_with(user.email, user.password)
    expect(page).to have_content("Welcome back #{user.email}")
  end

  context "should fail" do
    # TODO: Add proper error messages for all these failures
    it "with invalid email" do
      user.email= "hello"
      sign_in_with(user.email, user.password)
      expect(page).not_to have_content("Welcome back #{user.email}")
    end
    it "with blank email" do
      user.email= ""
      sign_in_with(user.email, user.password)
      expect(page).not_to have_content("Welcome back #{user.email}")
    end
    it "with invalid password" do
      user.password= "hello"
      sign_in_with(user.email, user.password)
      expect(page).not_to have_content("Welcome back #{user.email}")
    end
    it "with blanks password" do
      user.password= ""
      sign_in_with(user.email, user.password)
      expect(page).not_to have_content("Welcome back #{user.email}")
    end
  end
end
