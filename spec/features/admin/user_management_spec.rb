require 'rails_helper'

RSpec.describe 'User management', type: :feature do

  let!(:admin) { create(:user, :admin) }
  let!(:volunteer) { create(:user, :volunteer) }

  before { login_as(admin) }

  describe 'user listing' do
    it 'includes all users' do
      visit users_path
      expect(page).to have_content(volunteer.first_name)
      expect(page).to have_content(volunteer.last_name)
      expect(page).to have_content(volunteer.email)
    end
  end

  describe 'user editing' do
    it 'allows editing' do
      visit users_path
      click_link "edit-user-#{volunteer.id}"
      expect(current_path).to eq edit_user_path(volunteer)

      fill_in 'Last name', with: 'New Name'
      click_button 'Save'

      expect(current_path).to eq users_path

      within("#user-#{volunteer.id}") do
        expect(page).to have_content 'New Name'
      end
    end
  end    
end
