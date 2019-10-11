require 'rails_helper'

RSpec.describe Admin::Friends::AnkleMonitorsController, type: :controller do
  let!(:community) { create :community }
  let!(:other_community) { create :community }
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing ankle_monitors in the user's community"  do
    let(:friend) { create :friend, community: community }
    describe 'GET #new' do
      it 'allows access' do
        get :new, params: { community_slug: community.slug, friend_id: friend.id }, format: 'js', xhr: true
        expect(response.successful?).to eq true
      end
    end

    describe 'POST #create' do
      let(:ankle_monitor) { build :ankle_monitor, friend: friend }
      it 'allows access' do
        ankle_monitor_count = AnkleMonitor.count
        post :create, params: { community_slug: community.slug, friend_id: friend.id, ankle_monitor: ankle_monitor.attributes }, format: 'js', xhr: true
        expect(AnkleMonitor.count).to eq ankle_monitor_count + 1
      end
    end

    describe 'GET #edit' do
      let(:ankle_monitor) { create :ankle_monitor, friend: friend }
      it 'allows access' do
        get :edit, params: { community_slug: community.slug, friend_id: friend.id, id: ankle_monitor.id }, format: 'js', xhr: true
        expect(response.successful?).to eq true
      end
    end

    describe 'PUT #update' do
      let!(:ankle_monitor) { create :ankle_monitor, friend: friend }
      it 'allows access' do
        ankle_monitor.bi_smart_link = true
        put :update, params: { community_slug: community.slug, friend_id: friend.id, id: ankle_monitor.id, ankle_monitor: ankle_monitor.attributes }, format: 'js', xhr: true
        expect(ankle_monitor.bi_smart_link).to eq true
      end
    end

    describe 'DELETE #destroy' do
      let!(:ankle_monitor) { create :ankle_monitor, friend: friend }
      it 'allows access' do
        ankle_monitor_count = AnkleMonitor.count
        delete :destroy, params: { community_slug: community.slug, friend_id: friend.id, id: ankle_monitor.id }, format: 'js', xhr: true
        expect(AnkleMonitor.count).to eq ankle_monitor_count - 1
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
      let(:ankle_monitor) { build :ankle_monitor, friend: friend }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, friend_id: friend.id, ankle_monitor: ankle_monitor.attributes }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:ankle_monitor) { create :ankle_monitor, friend: friend }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, friend_id: friend.id, id: ankle_monitor.id }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:ankle_monitor) { create :ankle_monitor, friend: friend }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, friend_id: friend.id, id: ankle_monitor.id, ankle_monitor: ankle_monitor.attributes }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'DELETE #destroy' do
      let!(:ankle_monitor) { create :ankle_monitor, friend: friend }
      it 'does NOT allow access' do
        expect { delete :destroy, params: { community_slug: other_community.slug, friend_id: friend.id, id: ankle_monitor.id }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end
  end
end
