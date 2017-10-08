require 'rails_helper'

RSpec.describe 'Volunteer managing asylum application drafts for shared friends', type: :feature, js: true do
  let!(:volunteer) { create(:user, :volunteer) }
  let!(:shared_friend) { create(:friend) }
  let!(:not_shared_friend) { create(:friend) }
  let!(:user_friend_association) { create(:user_friend_association, friend: shared_friend, user: volunteer)}
  before { login_as(volunteer) }

  describe 'viewing shared friend records' do
    before do
      visit root_path
      click_link 'Clinic'
    end

    it 'displays friend records associated with the volunteer' do
      expect(page).to have_content(shared_friend.name)
    end

    it 'does not display friend records NOT associated with the volunteer' do
      expect(page).not_to have_content(not_shared_friend.name)
    end
  end
end