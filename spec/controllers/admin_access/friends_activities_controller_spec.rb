require 'rails_helper'

RSpec.describe Admin::Friends::ActivitiesController, type: :controller do
  let!(:community) { create :community }
  let!(:other_community) { create :community }
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing activities in the user's community"  do
    let(:friend) { create :friend, community: community }
    describe 'GET #new' do
      it 'allows access' do
        get :new, params: { community_slug: community.slug, friend_id: friend.id }, format: 'js', xhr: true
        expect(response.successful?).to eq true
      end
    end

    describe 'POST #create' do
      let(:activity) { build :activity, region: community.region, friend: friend, location: create(:location), activity_type: create(:activity_type) }
      it 'allows access' do
        activity_count = Activity.count
        post :create, params: { community_slug: community.slug, friend_id: friend.id, activity: activity.attributes }, format: 'js', xhr: true
        expect(Activity.count).to eq activity_count + 1
      end
    end

    describe 'GET #edit' do
      let(:activity) { create :activity, region: community.region, friend: friend }
      it 'allows access' do
        get :edit, params: { community_slug: community.slug, friend_id: friend.id, id: activity.id }, format: 'js', xhr: true
        expect(response.successful?).to eq true
      end
    end

    describe 'PUT #update' do
      let!(:activity) { create :activity, region: community.region, friend: friend }
      it 'allows access' do
        activity_attributes = activity.attributes
        activity_attributes['notes'] = 'test test test'
        put :update, params: { community_slug: community.slug, friend_id: friend.id, id: activity.id, activity: activity_attributes }, format: 'js', xhr: true
        expect(activity.reload.notes).to eq 'test test test'
      end
    end

    describe 'DELETE #destroy' do
      let!(:activity) { create :activity, region: community.region, friend: friend }
      it 'allows access' do
        activity_count = Activity.count
        delete :destroy, params: { community_slug: community.slug, friend_id: friend.id, id: activity.id }, format: 'js', xhr: true
        expect(Activity.count).to eq activity_count - 1
      end
    end

    describe 'POST #confirm' do
      let!(:activity) { create :activity, region: community.region, friend: friend }
      it 'allows access' do
        post :confirm, params: { community_slug: community.slug, friend_id: friend.id, id: activity.id }, format: 'js', xhr: true
        expect(response.successful?).to eq true
      end
    end
  end

  describe "managing activities NOT in the user's community"  do
    let(:friend) { create :friend, community: other_community }
    describe 'GET #new' do
      it 'does NOT allow access' do
        expect { get :new, params: { community_slug: other_community.slug, friend_id: friend.id }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'POST #create' do
      let(:activity) { build :activity, region: other_community.region, friend: friend }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, friend_id: friend.id, activity: activity.attributes }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:activity) { create :activity, region: other_community.region, friend: friend }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, friend_id: friend.id, id: activity.id }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:activity) { create :activity, region: other_community.region, friend: friend }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, friend_id: friend.id, id: activity.id, activity: activity.attributes }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'DELETE #destroy' do
      let!(:activity) { create :activity, region: other_community.region, friend: friend }
      it 'does NOT allow access' do
        expect { delete :destroy, params: { community_slug: other_community.slug, friend_id: friend.id, id: activity.id }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'POST #confirm' do
      let!(:activity) { create :activity, region: other_community.region, friend: friend }
      it 'does NOT allow access' do
        expect { post :confirm, params: { community_slug: other_community.slug, friend_id: friend.id, id: activity.id }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end
  end
end
