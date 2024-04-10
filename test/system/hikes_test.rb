require "application_system_test_case"

class HikesTest < ApplicationSystemTestCase
  # setup do
  #   @hike = hikes(:one)
  # end

  # test "visiting the index" do
  #   visit hikes_url
  #   assert_selector "h1", text: "Hikes"
  # end

  # test "should create hike" do
  #   visit hikes_url
  #   click_on "New hike"

  #   fill_in "Alltrails link", with: @hike.alltrails_link
  #   fill_in "Date", with: @hike.date
  #   fill_in "Description", with: @hike.description
  #   fill_in "Driver compensation type", with: @hike.driver_compensation_type
  #   fill_in "Duration", with: @hike.duration
  #   fill_in "Elevation", with: @hike.elevation
  #   fill_in "Length", with: @hike.length
  #   fill_in "Metadata", with: @hike.metadata
  #   fill_in "Notes", with: @hike.notes
  #   fill_in "Route type", with: @hike.route_type
  #   fill_in "Suggested items", with: @hike.suggested_items
  #   fill_in "Time", with: @hike.time
  #   fill_in "Title", with: @hike.title
  #   fill_in "Trailhead address", with: @hike.trailhead_address
  #   fill_in "User", with: @hike.user_id
  #   click_on "Create Hike"

  #   assert_text "Hike was successfully created"
  #   click_on "Back"
  # end

  # test "should update Hike" do
  #   visit hike_url(@hike)
  #   click_on "Edit this hike", match: :first

  #   fill_in "Alltrails link", with: @hike.alltrails_link
  #   fill_in "Date", with: @hike.date
  #   fill_in "Description", with: @hike.description
  #   fill_in "Driver compensation type", with: @hike.driver_compensation_type
  #   fill_in "Duration", with: @hike.duration
  #   fill_in "Elevation", with: @hike.elevation
  #   fill_in "Length", with: @hike.length
  #   fill_in "Metadata", with: @hike.metadata
  #   fill_in "Notes", with: @hike.notes
  #   fill_in "Route type", with: @hike.route_type
  #   fill_in "Suggested items", with: @hike.suggested_items
  #   fill_in "Time", with: @hike.time
  #   fill_in "Title", with: @hike.title
  #   fill_in "Trailhead address", with: @hike.trailhead_address
  #   fill_in "User", with: @hike.user_id
  #   click_on "Update Hike"

  #   assert_text "Hike was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Hike" do
  #   visit hike_url(@hike)
  #   click_on "Destroy this hike", match: :first

  #   assert_text "Hike was successfully destroyed"
  # end
end
