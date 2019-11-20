require 'rails_helper'

RSpec.describe AccompanimentLeader::Friends::ActivitiesController, type: :controller do
  let!(:community) { create :community, :primary }
  let(:accompaniment_leader) { create :user, :accompaniment_leader, community: community }
  let(:friend) { create :friend, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(accompaniment_leader)
  end

  describe "accessing a activity's info" do
    context 'when the community is primary' do
      describe 'POST #create' do
        let!(:activity) { create :activity, region: community.region, friend: friend, confirmed: true, last_edited_by: accompaniment_leader.id }
          it 'allows access' do
            activity_count = Activity.count
            post :create, params: { community_slug: community.slug, friend_id: friend.id, activity: activity.attributes }, format: :json
            expect(Activity.count).to eq activity_count + 1
            expect(Activity.last.last_edited_by).to eq accompaniment_leader.id
          end
      end
    end
  end
end