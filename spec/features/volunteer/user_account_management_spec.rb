require 'rails_helper'

RSpec.describe 'User account management', type: :feature do

  let(:community) { create :community }
  let(:volunteer) { create(:user, :volunteer, community: community) }

  before { login_as(volunteer) }

  describe 'a volunteer editing their user account' do
    it 'allows editing' do
      visit edit_community_user_path(community, volunteer)

      expect(page).to have_content('My Information')

      fill_in 'Last Name', with: 'New Name'
      click_button 'Save'

      expect(current_path).to eq community_dashboard_path(community)

      within(".navbar") do
        expect(page).to have_content 'New Name'
      end
    end

    it 'does not allow editing other user accounts' do
      @other_user = create(:user, :volunteer, community: community)
      expect { visit edit_community_user_path(community, @other_user) }.to raise_error ActionController::RoutingError
    end
  end
end
