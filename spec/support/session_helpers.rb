# spec/support/session_helpers.rb
module Features
  module SessionHelpers
    def sign_up_with(first_name, last_name, email, password, password_confirmation)
      visit '/users/sign_up?'
      within ("#register_form") do
          fill_in "First name", with: first_name
          fill_in "Last name", with: last_name
          fill_in "Email", with: email
          fill_in "Password", with: password
          fill_in "Password confirmation", with: password_confirmation
      end
      click_button "Sign up"
    end

    def sign_in_with(email, password)
      visit '/users/sign_in?'
      within ("#signin_form") do
        fill_in "Email", with: email
        fill_in "Password", with: password
      end
      click_button "Sign in"
    end
  end
end