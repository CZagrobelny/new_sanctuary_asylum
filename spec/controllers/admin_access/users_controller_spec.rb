require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:community) { create :community }
  let!(:other_community) { create :community }
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing users in the user's community"  do
    describe 'GET #index' do
      it 'allows access' do
        get :index, params: { community_slug: community.slug }
        expect(response.successful?).to eq true
      end
    end

    describe 'GET #edit' do
      let(:user) { create :user, :volunteer, community: community }
      it 'allows access' do
        get :edit, params: { community_slug: community.slug, id: user.id }
        expect(response.successful?).to eq true
      end
    end

    describe 'PUT #update' do
      let!(:user) { create :user, community: community }
      it 'allows access' do
        user_attributes = user.attributes
        user_attributes['first_name'] = 'new name'
        put :update, params: { community_slug: community.slug, id: user.id, user: user_attributes }
        expect(user.reload.first_name).to eq 'new name'
      end
    end

    describe 'DELETE #destroy' do
      let!(:user) { create :user, community: community }
      it 'allows access' do
        user_count = User.count
        delete :destroy, params: { community_slug: community.slug, id: user.id }
        expect(User.count).to eq user_count - 1
      end
    end
  end

  describe "managing users NOT in the user's community"  do
    describe 'GET #index' do
      it 'does NOT allow access' do
        expect { get :index, params: { community_slug: other_community.slug } }.to raise_error('Not Found')
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
