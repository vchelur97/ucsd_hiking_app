require 'rails_helper'

RSpec.feature "Hike Management", type: :feature do
  before do
    user_login
  end

  describe 'Creating a hike' do
    it 'allows creating a new draft hike' do
      visit new_hike_path
      hike_attrs = attributes_for(:hike)
      fill_in 'Title', with: hike_attrs[:title]
      fill_in 'Description', with: hike_attrs[:description]
      fill_in 'Trailhead address', with: hike_attrs[:trailhead_address]
      fill_in 'Short description', with: hike_attrs[:short_description]
      fill_in 'Date', with: hike_attrs[:datetime].strftime('%Y-%m-%d')
      fill_in 'Time', with: hike_attrs[:datetime].strftime('%H:%M')

      # Manually set the status to draft using a hidden field (This is done by stimulus)
      find('#hike_status', visible: false).set('draft')

      select HikesController::DIFFICULTY_MAPPING[hike_attrs[:difficulty]], from: 'Difficulty'
      click_button 'Save as draft'

      @hike = Hike.last
      expect(page).to have_current_path(hike_path(@hike))
      expect(page).to have_content(@hike.title)
      expect(@hike.status).to eq('draft')
    end

    it 'tests autofilling of hike details', js: true do
      visit new_hike_path
      fill_in 'Alltrails link', with: 'https://www.alltrails.com/trail/us/california/el-cajon-mountain-trail'
      fill_in 'Description', with: 'A challenging hike with great views'
      wait_for_turbo

      expect(page).to have_field('Length', with: '11.0')
      expect(page).to have_field('Elevation', with: '3579')
    end

    it 'validates required fields' do
      visit new_hike_path
      hike_attrs = attributes_for(:hike)
      fill_in 'Date', with: hike_attrs[:datetime].strftime('%Y-%m-%d')
      fill_in 'Time', with: hike_attrs[:datetime].strftime('%H:%M')
      find('#hike_status', visible: false).set('draft')
      click_button 'Save as draft'

      @hike = Hike.last
      expect(page).to have_current_path(hike_path(@hike))
      click_link 'Edit hike'

      expect(page).to have_current_path(edit_hike_path(@hike))
      find('#hike_status', visible: false).set('review')
      click_button 'Send for review'

      expect(page).to have_content("can't be blank")
    end

    it 'allows updating a hike' do
      hike = create(:hike, :draft, host: @user)
      visit edit_hike_path(hike)

      fill_in 'Title', with: 'Updated Title'
      click_button 'Save as draft'

      expect(hike.reload.title).to eq('Updated Title')
    end
  end

  describe 'Publishing a hike' do
    let!(:draft_hike) { create(:hike, :draft, host: @user) }
    let(:board_user) { create(:user, :with_signed_waiver, :with_details, :admin) }

    it 'sends hike for review' do
      visit edit_hike_path(draft_hike)

      find('#hike_status', visible: false).set('review')
      click_button 'Send for review'
      expect(draft_hike.reload.status).to eq('review')
      expect(page).to have_current_path(hike_path(draft_hike))
    end

    it 'allows board member to review and approve' do
      draft_hike.update(status: 'review')

      user_logout
      user_login(board_user)

      expect(page).to have_content("Hikes for Review")
      visit edit_hike_path(draft_hike)

      find('#hike_status', visible: false).set('published')
      click_button 'Publish'

      expect(draft_hike.reload.status).to eq('published')
    end

    it 'prevents non-board members from approving hikes' do
      draft_hike.update(status: 'review')
      visit edit_hike_path(draft_hike)

      expect(page).not_to have_button("Publish")
    end

    it 'allows deleting a draft hike', js: true do
      visit hike_path(draft_hike)

      click_link "Delete hike"
      wait_for_element("button", text: "Delete")
      click_button "Delete"

      expect(page).to have_content('Hike was successfully deleted')
      expect(Hike.exists?(draft_hike.id)).to be false
    end
  end

  describe 'Viewing hike details' do
    let!(:hike) { create(:hike, :published) }

    it 'displays all hike information' do
      visit hike_path(hike)
      expect(page).to have_content(hike.title)
      expect(page).to have_content(hike.length)
      expect(page).to have_content(hike.elevation)
      expect(page).to have_content(hike.duration)
      expect(page).to have_content(hike.route_type)
      expect(page).to have_content(hike.host.full_name)
    end

    it 'allows viewing the hike index' do
      visit hikes_path
      expect(page).to have_content(hike.title)
      expect(page).to have_content(hike.short_description)
    end
  end
end
