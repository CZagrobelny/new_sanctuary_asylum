require 'rails_helper'

RSpec.describe Admin::FriendsController, type: :controller do
  let!(:community) { create :community }
  let!(:other_community) { create :community }
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing friends in the user's community"  do
    describe 'GET #index' do
      it 'allows access' do
        get :index, params: { community_slug: community.slug }
        expect(response.successful?).to eq true
      end
    end

    describe 'GET #new' do
      it 'allows access' do
        get :new, params: { community_slug: community.slug }
        expect(response.successful?).to eq true
      end
    end

    describe 'POST #create' do
      let(:friend) { build :friend, community: community }
      it 'allows access' do
        friend_count = Friend.count
        post :create, params: { community_slug: community.slug, friend: friend.attributes }
        expect(Friend.count).to eq friend_count + 1
      end
    end

    describe 'GET #edit' do
      let(:friend) { create :friend, community: community }
      it 'allows access' do
        get :edit, params: { community_slug: community.slug, id: friend.id }
        expect(response.successful?).to eq true
      end
    end

    describe 'PUT #update' do
      let!(:friend) { create :friend, community: community }
      it 'allows access' do
        friend.first_name = 'new name'
        put :update, params: { community_slug: community.slug, id: friend.id, friend: friend.attributes }
        expect(friend.first_name).to eq 'new name'
      end
    end

    describe 'DELETE #destroy' do
      let!(:friend) { create :friend, community: community }
      it 'allows access' do
        friend_count = Friend.count
        delete :destroy, params: { community_slug: community.slug, id: friend.id }
        expect(Friend.count).to eq friend_count - 1
      end
    end
  end

  describe "managing friends NOT in the user's community"  do
    describe 'GET #index' do
      it 'does NOT allow access' do
        expect { get :index, params: { community_slug: other_community.slug } }.to raise_error('Not Found')
      end
    end

    describe 'GET #new' do
      it 'does NOT allow access' do
        expect { get :new, params: { community_slug: other_community.slug } }.to raise_error('Not Found')
      end
    end

    describe 'POST #create' do
      let(:friend) { build :friend, community: other_community }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, friend: friend.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:friend) { create :friend, community: other_community }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, id: friend.id } }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:friend) { create :friend, community: other_community }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, id: friend.id, friend: friend.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'DELETE #destroy' do
      let!(:friend) { create :friend, community: other_community }
      it 'does NOT allow access' do
        expect { delete :destroy, params: { community_slug: other_community.slug, id: friend.id } }.to raise_error('Not Found')
      end
    end
  end
end
