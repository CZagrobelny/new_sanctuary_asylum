require 'rails_helper'

RSpec.describe Admin::Friends::DetentionsController, type: :controller do
  let!(:community) { create :community }
  let!(:other_community) { create :community }
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing detentions in the user's community"  do
    let(:friend) { create :friend, community: community }
    describe 'GET #new' do
      it 'allows access' do
        get :new, params: { community_slug: community.slug, friend_id: friend.id }, format: 'js', xhr: true
        expect(response.successful?).to eq true
      end
    end

    describe 'POST #create' do
      let(:detention) { build :detention, friend: friend, location: create(:location) }
      it 'allows access' do
        detention_count = Detention.count
        post :create, params: { community_slug: community.slug, friend_id: friend.id, detention: detention.attributes }, format: 'js', xhr: true
        expect(Detention.count).to eq detention_count + 1
      end
    end

    describe 'GET #edit' do
      let(:detention) { create :detention, friend: friend }
      it 'allows access' do
        get :edit, params: { community_slug: community.slug, friend_id: friend.id, id: detention.id }, format: 'js', xhr: true
        expect(response.successful?).to eq true
      end
    end

    describe 'PUT #update' do
      let!(:detention) { create :detention, friend: friend }
      it 'allows access' do
        detention_attributes = detention.attributes
        detention_attributes['case_status'] = 'circuit_court'
        put :update, params: { community_slug: community.slug, friend_id: friend.id, id: detention.id, detention: detention_attributes }, format: 'js', xhr: true
        expect(detention.reload.case_status).to eq 'circuit_court'
      end
    end

    describe 'DELETE #destroy' do
      let!(:detention) { create :detention, friend: friend }
      it 'allows access' do
        detention_count = Detention.count
        delete :destroy, params: { community_slug: community.slug, friend_id: friend.id, id: detention.id }, format: 'js', xhr: true
        expect(Detention.count).to eq detention_count - 1
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
      let(:detention) { build :detention, friend: friend }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, friend_id: friend.id, detention: detention.attributes }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:detention) { create :detention, friend: friend }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, friend_id: friend.id, id: detention.id }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:detention) { create :detention, friend: friend }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, friend_id: friend.id, id: detention.id, detention: detention.attributes }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end

    describe 'DELETE #destroy' do
      let!(:detention) { create :detention, friend: friend }
      it 'does NOT allow access' do
        expect { delete :destroy, params: { community_slug: other_community.slug, friend_id: friend.id, id: detention.id }, format: 'js', xhr: true }.to raise_error('Not Found')
      end
    end
  end
end