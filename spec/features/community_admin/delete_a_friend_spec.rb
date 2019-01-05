require 'rails_helper'

RSpec.describe 'Admin deletes a friend record', type: :feature, js: :true do

  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community }
  let!(:keeper) { create(:friend, first_name: 'Persistent', last_name: 'Record', community: community) }
  let(:deleteable) { create(:friend, first_name: 'Deleteable', last_name: 'Record', community: community) }

  before do
    # (Re)create deleteable record since scenario deleted it
    deleteable

    login_as(community_admin)
  end

  describe 'when I delete a Friend record' do
    scenario 'I visit the community admin page' do
      visit community_admin_friends_path(community)
      expect(page).to have_content('Deleteable')
      expect(page).to have_content('Persistent')

      within("tr#friend-#{deleteable.id}") do
        # Delete is in Bootstrap dropdown so open that first
        find('button').click
        click_link 'Delete'
      end

      expect(page).to have_content('Friend record destroyed')
      expect(page).to_not have_content('Deleteable')
      expect(page).to have_content('Persistent')
    end
  end
end
