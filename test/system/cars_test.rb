require "application_system_test_case"

class CarsTest < ApplicationSystemTestCase
  setup do
    @car = cars(:one)
  end

  test "visiting the index" do
    visit cars_url
    assert_selector "h1", text: "Cars"
  end

  test "should create car" do
    visit cars_url
    click_on "New car"

    fill_in "Capacity", with: @car.capacity
    fill_in "Color", with: @car.color
    fill_in "License plate", with: @car.license_plate
    fill_in "Make", with: @car.make
    fill_in "Model", with: @car.model
    fill_in "Mpg", with: @car.mpg
    fill_in "User", with: @car.user_id
    click_on "Create Car"

    assert_text "Car was successfully created"
    click_on "Back"
  end

  test "should update Car" do
    visit car_url(@car)
    click_on "Edit this car", match: :first

    fill_in "Capacity", with: @car.capacity
    fill_in "Color", with: @car.color
    fill_in "License plate", with: @car.license_plate
    fill_in "Make", with: @car.make
    fill_in "Model", with: @car.model
    fill_in "Mpg", with: @car.mpg
    fill_in "User", with: @car.user_id
    click_on "Update Car"

    assert_text "Car was successfully updated"
    click_on "Back"
  end

  test "should destroy Car" do
    visit car_url(@car)
    click_on "Destroy this car", match: :first

    assert_text "Car was successfully destroyed"
  end
end
