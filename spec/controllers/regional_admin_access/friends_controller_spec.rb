require 'rails_helper'

RSpec.describe RegionalAdmin::FriendsController, type: :controller do

  let(:community) { create :community, region: region }
  let(:region) { create :region }
  let(:friend) { create :friend, community: community, region: region }

  describe 'as a logged in regional admin' do
    let(:regional_admin) { create :user, :regional_admin, community: community }

    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(regional_admin)
    end

    describe 'GET #show' do
      it 'allows access' do
        get :show, params: { region_id: region.id, id: friend.id }
        expect(response.successful?).to eq true
      end
    end

    describe 'PUT #update' do
      let(:user) { create :user, :remote_clinic_lawyer }
      it 'updates the friend' do
        user_friend_association_count = UserFriendAssociation.count
        put :update, params: { region_id: region.id, id: friend.id, friend: { remote_clinic_lawyer_user_ids: [user.id] } }
        expect(UserFriendAssociation.count).to eq user_friend_association_count + 1
      end
    end
  end

  describe 'as a logged in community admin' do
    let(:community_admin) { create :user, :community_admin, community: community }

    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(community_admin)
    end

    describe 'GET #new' do
      it 'does NOT allow access' do
        expect{ get :show, params: { region_id: region.id, id: friend.id } }.to raise_error('Not Found')
      end
    end
  end
end
