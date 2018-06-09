require 'rails_helper'

RSpec.describe 'User management', type: :feature do

  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community }
  let!(:volunteer) { create(:user, :volunteer, community: community) }

  before { login_as(community_admin) }

  describe 'user listing' do
    it 'includes all users' do
      visit community_admin_users_path(community)
      expect(page).to have_content(volunteer.first_name)
      expect(page).to have_content(volunteer.last_name)
      expect(page).to have_content(volunteer.email)
    end
  end

  describe 'user editing' do
    it 'allows editing' do
      visit community_admin_users_path(community)
      click_link "edit-user-#{volunteer.id}"
      expect(current_path).to eq edit_community_admin_user_path(community, volunteer)

      fill_in 'Last Name', with: 'New Name'
      click_button 'Save'

      expect(current_path).to eq community_admin_users_path(community)

      within("#user-#{volunteer.id}") do
        expect(page).to have_content 'New Name'
      end
    end
  end
end
