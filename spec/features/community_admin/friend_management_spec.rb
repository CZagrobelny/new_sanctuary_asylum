require 'rails_helper'

RSpec.describe 'Friend management', type: :feature do

  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community }
  let!(:friend) { create(:friend, community: community) }

  before { login_as(community_admin) }

  describe 'friends listing' do
    it 'includes all friends' do
      visit community_admin_friends_path(community)
      expect(page).to have_content(friend.first_name)
      expect(page).to have_content(friend.last_name)
      expect(page).to have_content(friend.a_number)
    end
  end

  describe 'friend editing' do
    it 'allows editing' do
      visit community_admin_friends_path(community)
      click_link "edit-friend-#{friend.id}"
      expect(current_path).to eq edit_community_admin_friend_path(community, friend)
    end
  end

  scenario 'viewing activity for a friend shows hidden judge' do
    judge = create(:judge, region: community.region, hidden: true)
    create(:activity, judge: judge, friend: friend)

    visit community_admin_friends_path(community)
    click_link "edit-friend-#{friend.id}"
    click_link 'Activities/Accompaniments'
    expect(page).to have_content("Judge: #{judge.name}")
  end
end
