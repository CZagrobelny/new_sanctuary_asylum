require 'rails_helper'

RSpec.describe 'Admin deletes a user record', type: :feature, js: :true do

  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community }
  let!(:keeper) { create(:user, :volunteer, first_name: 'Persistent', last_name: 'Record', community: community) }
  let(:deleteable) { create(:user, :volunteer, first_name: 'Deleteable', last_name: 'Record', community: community) }

  before do
    # (Re)create deleteable record since scenario deleted it
    deleteable

    login_as(community_admin)
    visit community_admin_users_path(community)
  end

  describe 'when I delete a User record' do
    scenario 'with no search terms' do
      expect(page).to have_content('Deleteable')
      expect(page).to have_content('Persistent')

      within("tr#user-#{deleteable.id}") do
        # Delete is in Bootstrap dropdown so open that first
        find('button').click
        click_link 'Delete'
      end

      expect(page).to have_content('User record deleted')
      expect(page).to_not have_content('Deleteable')
      expect(page).to have_content('Persistent')
    end

    scenario 'with search terms' do
      fill_in id: 'query', with: "Deleteable"
      find('#query').native.send_keys(:return)

      expect(page).to have_content('Deleteable')
      expect(page).to_not have_content('Persistent')

      within("tr#user-#{deleteable.id}") do
        # Delete is in Bootstrap dropdown so open that first
        find('button').click
        click_link 'Delete'
      end

      expect(page).to have_content('User record deleted')
      expect(page).to_not have_content('Deleteable')
      expect(page).to_not have_content('Persistent')
    end
  end
end
