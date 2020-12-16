require 'rails_helper'

RSpec.describe 'Give volunteers access to friends', type: :feature, js: true do
  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community }
  let!(:friend) { create(:friend, community: community) }
  let!(:volunteer) { create(:user, :volunteer, community: community) }

  describe 'An admin adds a volunteer to a friend record' do
    it 'allows the volunteer access to the record' do
      login_as(community_admin)
      visit edit_community_admin_friend_path(community, friend)
      click_link 'Access'
      select2 volunteer.name, from: 'Volunteers with Access', search: true
      within '#submission_wrapper' do
        click_button 'Save'
      end
      logout(:user)
      login_as(volunteer)
      visit community_friend_path(community, friend)

      expect(page).to have_content 'Basic'
      expect(page).to have_content 'Documents'
      expect(page).to have_content 'Access'
    end
  end
end