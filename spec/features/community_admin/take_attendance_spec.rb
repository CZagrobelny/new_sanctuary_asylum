require 'rails_helper'

RSpec.describe 'Take attendance', type: :feature, js: true do
  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community, :primary }
  let!(:event) { create(:event, community: community) }
  let!(:attending_volunteer) { create(:user, :volunteer, community: community) }
  let(:attending_volunteer_name) { "#{attending_volunteer.last_name}, #{attending_volunteer.first_name}" }
  let!(:not_attending_volunteer) { create(:user, :volunteer, community: community) }
  let(:not_attending_volunteer_name) { "#{not_attending_volunteer.last_name}, #{not_attending_volunteer.first_name}" }
  let!(:attending_friend) { create(:friend, community: community) }
  let(:attending_friend_name) { "#{attending_friend.last_name}, #{attending_friend.first_name}" }
  let!(:not_attending_friend) { create(:friend, community: community) }
  let(:not_attending_friend_name) { "#{not_attending_friend.last_name}, #{not_attending_friend.first_name}" }

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
      expect(page).to have_content(attending_volunteer_name)
    end

    it 'does NOT display the names of volunteers NOT attending' do
      expect(page).to_not have_content(not_attending_volunteer_name)
    end

    describe 'adding a volunteer to the attendance list' do
      it 'displays the volunteer name' do
        select2 not_attending_volunteer.name, from: 'Volunteers Attending', search: true
        expect(page).to have_content(not_attending_volunteer_name)
      end
    end
  end

  describe 'taking friend attendance' do
    it 'displays the names of attending friends' do
      expect(page).to have_content(attending_friend_name)
    end

    it 'does NOT display the names of friends NOT attending' do
      expect(page).to_not have_content(not_attending_friend_name)
    end

    describe 'adding a friend to the attendance list' do
      it 'displays the friend name' do
        select2 not_attending_friend.name, from: 'Friends Attending', search: true
        expect(page).to have_content(not_attending_friend_name)
      end
    end
  end
end