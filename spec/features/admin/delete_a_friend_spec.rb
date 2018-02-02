require 'rails_helper'

RSpec.describe 'Admin deletes a friend record', type: :feature, js: :true do

  let!(:admin) { create(:user, :admin) }
  let!(:keeper) { create(:friend, first_name: 'Persistent', last_name: 'Record') }
  let(:deleteable) { create(:friend, first_name: 'Deleteable', last_name: 'Record') }

  before do
    # (Re)create deleteable record since scenario deleted it
    deleteable

    login_as(admin)
    visit admin_friends_path
  end

  describe 'when I delete a Friend record' do
    scenario 'with no search terms' do
      expect(page).to have_content('Deleteable')
      expect(page).to have_content('Persistent')

      within("tr#friend-#{deleteable.id}") do
        # Delete is in Bootstrap dropdown so open that first
        find('button').click
        click_link 'Delete'
      end

      expect(page).to_not have_content('Deleteable')
      expect(page).to have_content('Persistent')
    end

    scenario 'with search terms' do
      fill_in id: 'query', with: "Deleteable"
      find('#query').native.send_keys(:return)

      expect(page).to have_content('Deleteable')
      expect(page).to_not have_content('Persistent')

      within("tr#friend-#{deleteable.id}") do
        # Delete is in Bootstrap dropdown so open that first
        find('button').click
        click_link 'Delete'
      end

      expect(page).to_not have_content('Deleteable')
      expect(page).to_not have_content('Persistent')
    end
  end
end
