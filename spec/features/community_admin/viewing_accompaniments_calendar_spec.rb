require 'rails_helper'

RSpec.describe 'Community Admin viewing the accompaniments calendar', type: :feature do
  let(:community_admin) { create :user, :community_admin, community: community }
  let(:community) { create :community, :primary }
  let(:region) { community.region }
  let(:team_leader) { create(:user, :accompaniment_leader, community: community) }
  let!(:activity) { create(:activity, occur_at: 1.hour.from_now, region: region, confirmed: true) }
  let!(:accompaniment) { create(:accompaniment, user: team_leader, activity: activity) }

  before do
    login_as(community_admin)
  end

  describe 'viewing the accompaniments calendar' do
    before(:each) do
      visit accompaniments_community_admin_activities_path(community.slug)
    end

    it 'displays the activity event' do
      expect(page).to have_content(activity.event.humanize)
    end

    it 'displays the activity friend name' do
      expect(page).to have_content(activity.friend.name)
    end

    it 'displays the number of volunteers' do
      expect(page).to have_content(activity.volunteer_accompaniments.count)
    end
  end
end