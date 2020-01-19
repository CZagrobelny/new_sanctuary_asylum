require 'rails_helper'

RSpec.describe 'Admin creates a new friend record', type: :feature do

  let(:community_admin) { create(:user, :community_admin) }
  let(:community) { community_admin.community }

  before do
    login_as(community_admin)
    visit new_community_admin_friend_path(community)
  end

  describe 'when I visit /admin/friends/new' do
    it 'shows only the "Basic" tab' do
      within '.nav-tabs' do
        expect(page).to have_content('Basic')
        expect(page).to_not have_content('Family')
        expect(page).to_not have_content('Activities')
        expect(page).to_not have_content('Asylum')
        expect(page).to_not have_content('Other Case Info')
      end
    end
  end

  describe 'creating a friend' do
    scenario 'with valid inputs' do
      fill_in 'First Name', with: Faker::Name.first_name
      fill_in 'Last Name', with: Faker::Name.last_name
      fill_in 'A Number', with: '123456789'
      select 'Female', from: 'Gender'
      click_button 'Save'

      within '.alert' do
        expect(page).to have_content 'Friend record saved.'
      end

      expect(current_path).to eq edit_community_admin_friend_path(community, Friend.first)
    end

    scenario 'with invalid inputs' do
      fill_in 'First Name', with: ''
      fill_in 'Last Name', with: Faker::Name.last_name
      fill_in 'A Number', with: '123456789'
      select 'Female', from: 'Gender'
      click_button 'Save'

      within '.alert' do
        expect(page).to have_content 'Friend record not saved.'
      end

      expect(page).to have_content "First name can't be blank"
    end
  end
end