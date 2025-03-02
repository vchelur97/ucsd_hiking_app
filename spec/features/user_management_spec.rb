require 'rails_helper'

RSpec.feature "User Management", type: :feature do
  context "A new user with a valid UCSD Google account" do
    before do
      set_google_omniauth
    end

    scenario "Logs in" do
      visit new_user_session_path
      click_button "Sign in with Google"
      expect(User.last.roles).to include('hiker')
      expect(page).to have_current_path(new_user_waiver_path)
    end

    scenario "Logs out after sign in" do
      visit new_user_session_path
      click_button "Sign in with Google"
      click_link "Log out"
      expect(page).to have_content("Logged out")
    end

    scenario "Signs waiver and updates phone number" do
      visit new_user_session_path
      click_button "Sign in with Google"
      page.driver.header('User-Agent',
                         'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)\
                        Chrome/58.0.3029.110 Safari/537.3')
      click_button "Sign Waiver"
      expect(page).to have_current_path(edit_user_path)
      fill_in "user_phone_no", with: "9876543210"
      click_button "Update User"
      expect(page).to have_current_path(user_path)
    end
  end

  context "A new user with an invalid (non-UCSD) Google account" do
    before do
      set_google_omniauth(attributes_for(:user, :with_non_ucsd_email))
    end

    scenario "Sees help page on log in" do
      visit new_user_session_path
      click_button "Sign in with Google"
      expect(page).to have_current_path(help_path)
      expect(User.last.roles).not_to include('hiker')
      expect(page).not_to have_link("Hikes")
      expect(page).not_to have_link("Host")
    end
  end

  context "User manages profile", js: true do
    before do
      user_login
    end

    scenario "Updates profile information" do
      visit edit_user_path
      fill_in "user_phone_no", with: "1234567890"
      click_button "Update User"
      expect(page).to have_content("Profile was successfully updated")
      expect(User.first.phone_no).to eq("1234567890")
    end

    scenario "Views profile information" do
      visit user_path
      expect(page).to have_content(User.first.email)
      expect(page).to have_content(User.first.phone_no)
    end
  end

  context "User manages cars" do
    before do
      user_login
    end

    scenario "User creates a new car" do
      car_attributes = attributes_for(:car)
      visit user_path
      click_link "Add car"

      fill_in "car_make", with: car_attributes[:make]
      fill_in "car_model", with: car_attributes[:model]
      fill_in "car_color", with: car_attributes[:color]
      fill_in "car_capacity", with: car_attributes[:capacity]
      click_button "Create Car"

      expect(page).to have_content(car_attributes[:make])
    end

    scenario "User views car list" do
      create(:car, user: User.first)
      visit user_path
      expect(page).to have_content(Car.last.make)
      expect(page).to have_content(Car.last.model)
    end

    scenario "User updates car information" do
      car = create(:car, user: User.first)
      visit edit_car_path(car)
      fill_in "car_make", with: "Updated Make"
      click_button "Update Car"
      expect(page).to have_content("Updated Make")
    end

    scenario "User deletes a car", js: true do
      car = create(:car, user: User.first)
      visit user_path
      click_link "Edit car"

      click_link "Delete car"
      wait_for_element("button", text: "Delete")
      click_button "Delete"

      expect(page).not_to have_content(car.make)
      expect(page).not_to have_content(car.model)
    end
  end
end
