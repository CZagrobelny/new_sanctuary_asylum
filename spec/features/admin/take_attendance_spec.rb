require 'rails_helper'

RSpec.describe 'Take attendance', type: :feature, js: true do
  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community }
  let!(:event) { create(:event, community: community) }
  let!(:attending_volunteer) { create(:user, :volunteer, community: community) }
  let!(:not_attending_volunteer) { create(:user, :volunteer, community: community) }
  let!(:attending_friend) { create(:friend, community: community) }
  let!(:not_attending_friend) { create(:friend, community: community) }

  before do
    create(:user_event_attendance, event: event, user: attending_volunteer)
    3.times { create(:user_event_attendance, event: event) }
    create(:friend_event_attendance, event: event, friend: attending_friend)
    3.times { create(:friend_event_attendance, event: event) }
    login_as(community_admin)
    visit attendance_community_admin_event_path(community, event)
  end

  describe 'taking volunteer attendance' do
    it 'displays the names of attending volunteers' do
      expect(page).to have_content(attending_volunteer.name)
    end

    it 'does NOT display the names of volunteers NOT attending' do
      expect(page).to_not have_content(not_attending_volunteer.name)
    end

    describe 'adding a volunteer to the attendance list' do
      it 'displays the volunteer name' do
        select_from_multi_chosen(not_attending_volunteer.name, from: {id: 'user_event_attendance_user_id'})
        expect(page).to have_content(not_attending_volunteer.name)
      end
    end
  end

  describe 'taking friend attendance' do
    it 'displays the names of attending friends' do
      expect(page).to have_content(attending_friend.name)
    end

    it 'does NOT display the names of friends NOT attending' do
      expect(page).to_not have_content(not_attending_friend.name)
    end

    describe 'adding a friend to the attendance list' do
      it 'displays the friend name' do
        select_from_multi_chosen(not_attending_friend.name, from: {id: 'friend_event_attendance_friend_id'})
        expect(page).to have_content(not_attending_friend.name)
      end
    end
  end
end