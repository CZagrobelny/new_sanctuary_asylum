require 'rails_helper'

RSpec.describe 'Friend management', type: :feature do

  let!(:admin) { create(:user, :admin) }
  let!(:friend) { create(:friend) }

  before { login_as(admin) }

  describe 'friends listing' do
    it 'includes all friends' do
      visit admin_friends_path
      expect(page).to have_content(friend.first_name)
      expect(page).to have_content(friend.last_name)
      expect(page).to have_content(friend.a_number)
    end
  end

  describe 'friend editing' do
    it 'allows editing' do
      visit admin_friends_path
      click_link "edit-friend-#{friend.id}"
      expect(current_path).to eq edit_admin_friend_path(friend)
    end
  end 
end
