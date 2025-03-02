require 'rails_helper'

RSpec.feature "Hike Participation", type: :feature, js: true do
  include ActionView::RecordIdentifier

  let(:user) { create(:user, :with_signed_waiver, :with_details, :hiker) }
  let!(:user_car) { create(:car, user: user, make: "Honda", model: "Civic", color: "Red") }
  let(:driver) { create(:user, :with_signed_waiver, :with_details, :hiker) }
  let!(:driver_car) { create(:car, user: driver, make: "Toyota", model: "Camry", color: "Blue", capacity: 4) }
  let(:hike) { create(:hike, :published, datetime: 1.week.from_now, host: driver) }

  before do
    user_login(user)
  end

  describe 'joining a car' do
    let!(:hike_car) { create(:hike_car, hike: hike, car: driver_car, pickup_time: "PC Loop@9:30AM") }

    it 'shows available cars with join option' do
      visit hike_path(hike)

      # Car info should be visible
      within("##{dom_id(hike_car)}") do
        expect(page).to have_content("Toyota Camry")
        expect(page).to have_content("Blue")
        expect(page).to have_content("PC Loop")
        expect(page).to have_content("4 spots")
      end

      # Join using form
      within("#new_#{dom_id(hike_car)}_participant") do
        fill_in "hike_participant[note]", with: "Need early pickup"
        click_button "Join hike"
      end

      visit hike_path(hike)

      participant = HikeParticipant.last
      expect(participant.user).to eq(user)
      expect(participant.hike_car).to eq(hike_car)
      expect(participant.note).to eq("Need early pickup")
    end

    it 'hides join option for full cars' do
      driver_car.capacity.times do
        create(:hike_participant, hike_car: hike_car)
      end

      visit hike_path(hike)
      expect(page).not_to have_selector("#new_#{dom_id(hike_car)}_participant")
    end
  end

  describe 'adding a car' do
    it 'allows adding a car to the hike' do
      visit hike_path(hike)

      # Wait for the form to appear
      wait_for_element("#new_hike_car")
      within("#new_hike_car") do
        select "#{user_car.make} #{user_car.model}", from: "Car"
        fill_in "Spots", with: "3"
        fill_in "Pickup@ Time", with: "PC Loop@9:30AM"
        fill_in "Pickup Address", with: "https://maps.google.com"
        fill_in "Compensation", with: "10"
        fill_in "Note", with: "Will stop for coffee"
        click_button "Add car"
      end

      # Wait for turbo operations to complete after submission
      wait_for_turbo
      visit hike_path(hike)

      hike_car = HikeCar.last
      expect(hike_car.car).to eq(user_car)
      expect(hike_car.spots_available).to eq("3")
      expect(hike_car.note).to eq("Will stop for coffee")
    end
  end

  describe 'managing participation' do
    let!(:hike_car) { create(:hike_car, hike: hike, car: driver_car) }

    it 'allows participant to leave' do
      participant = create(:hike_participant, hike_car: hike_car, user: user)
      visit hike_path(hike)
      wait_for_turbo

      click_link "delete_#{dom_id(participant)}"
      click_button "Delete"

      wait_for_turbo
      visit hike_path(hike)
      expect(HikeParticipant.exists?(participant.id)).to be false
    end

    it 'allows driver to remove participants' do
      participant = create(:hike_participant, hike_car: hike_car, user: user)
      user_login(driver)
      visit hike_path(hike)
      wait_for_turbo

      click_link "delete_#{dom_id(participant)}"
      wait_for_element("button", text: "Delete")
      click_button "Delete"

      wait_for_turbo
      visit hike_path(hike)
      expect(HikeParticipant.exists?(participant.id)).to be false
    end

    it 'allows admin to remove participants' do
      participant = create(:hike_participant, hike_car: hike_car, user: user)
      admin = create(:user, :admin, :with_signed_waiver, :with_details)
      user_login(admin)
      visit hike_path(hike)
      wait_for_turbo

      wait_for_element("a[id='delete_#{dom_id(participant)}']")
      click_link "delete_#{dom_id(participant)}"
      wait_for_element("button", text: "Delete")
      click_button "Delete"

      wait_for_turbo
      visit hike_path(hike)
      wait_for_turbo
      expect(HikeParticipant.exists?(participant.id)).to be false
    end
  end
end
