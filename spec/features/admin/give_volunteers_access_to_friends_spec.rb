require 'rails_helper'

RSpec.describe 'Give volunteers access to friends', type: :feature, js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:friend) { create(:friend) }
  let!(:volunteer) { create(:user, :volunteer) }

  describe 'An admin adds a volunteer to a friend record' do
    it 'allows the volunteer access to the record' do
      login_as(admin)
      visit edit_admin_friend_path(friend)
      click_link 'Access'
      select_from_multi_chosen(volunteer.name, from: {id: 'friend_user_ids'})
      within '#submission_wrapper' do
        click_button 'Save'
      end
      logout(:user)
      login_as(volunteer)
      visit friend_path(friend)

      expect(page).to have_content 'Basic'
      expect(page).to have_content 'Documents'
      expect(page).to have_content 'Access'
    end
  end
end