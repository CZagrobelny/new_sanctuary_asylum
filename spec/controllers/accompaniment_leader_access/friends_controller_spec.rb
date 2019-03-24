require 'rails_helper'

RSpec.describe AccompanimentLeader::FriendsController, type: :controller do
  let(:accompaniment_leader) { create :user, :accompaniment_leader, community: community }
  let!(:activity) { create :activity, region: community.region, friend: friend, confirmed: true, occur_at: activity_occur_at }
  let(:friend) { create :friend, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(accompaniment_leader)
  end

  describe "accessing a friend's info" do
    context 'when the community is primary' do
      let(:community) { create :community, :primary }

      context 'when the accompaniment leader is attending an accompaniment for the friend in a 5 week date range' do
        let(:activity_occur_at) { Time.now }
        before { create(:accompaniment, user: accompaniment_leader, activity: activity) }
        describe 'GET #show' do
          it 'allows access' do
            get :show, params: { community_slug: community.slug, id: friend.id }
            expect(response.successful?).to eq true
          end
        end
      end

      context 'when the accompaniment leader has attended an accompaniment for the friend, BUT it falls outside of the 5 week date range' do
        let(:activity_occur_at) { 4.weeks.ago }
        before { create(:accompaniment, user: accompaniment_leader, activity: activity) }
        describe 'GET #show' do
          it 'does NOT allow access' do
            expect { get :show, params: { community_slug: community.slug, id: friend.id } }.to raise_error('Not Found')
          end
        end
      end

      context 'when the friend has an accompaniment eligible in the 5 week date range, BUT the accompaniment_leader is not attending' do
        let(:activity_occur_at) { Time.now }
        describe 'GET #show' do
          it 'does NOT allow access' do
            expect { get :show, params: { community_slug: community.slug, id: friend.id } }.to raise_error('Not Found')
          end
        end
      end
    end
  end
end