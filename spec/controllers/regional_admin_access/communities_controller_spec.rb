require 'rails_helper'

RSpec.describe RegionalAdmin::CommunitiesController, type: :controller do
  let(:community) { create :community, region: region }
  let(:region) { create :region }

  describe 'as a logged in regional admin' do
    let(:regional_admin) { create :user, :regional_admin, community: community }

    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(regional_admin)
    end

    describe 'GET #index' do
      it 'allows access' do
        get :index, params: { region_id: region.id }
        expect(response.success?).to eq true
      end
    end

    describe 'GET #new' do
      it 'allows access' do
        get :new, params: { region_id: region.id }
        expect(response.success?).to eq true
      end
    end

    describe 'POST #create' do
      let(:new_community) { build :community, region: region }

      it 'allows access' do
        community_count = Community.count
        post :create, params: { region_id: region.id, community: new_community.attributes }
        expect(Community.count).to eq community_count + 1
      end
    end

    describe 'GET #edit' do
      it 'allows access' do
        get :edit, params: { region_id: region.id, id: community.id }
        expect(response.success?).to eq true
      end
    end

    describe 'PUT #update' do
      it 'updates the community' do
        put :update, params: { region_id: region.id, id: community.slug, community: { name: 'Updated Name' } }
        expect(community.reload.name).to eq 'Updated Name'
      end
    end
  end

  describe 'as a logged in community admin' do
    let(:community_admin) { create :user, :community_admin, community: community }

    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(community_admin)
    end

    describe 'GET #index' do
      it 'does NOT allow access' do
        expect{ get :index, params: { region_id: region.id } }.to raise_error('Not Found')
      end
    end

    describe 'GET #new' do
      it 'does NOT allow access' do
        expect{ get :new, params: { region_id: region.id } }.to raise_error('Not Found')
      end
    end

    describe 'POST #create' do
      let(:new_community) { build :community, region: region }

      it 'does NOT allow access' do
        expect{ post :create, params: { region_id: region.id, community: new_community.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      it 'does NOT allow access' do
        expect{ get :edit, params: { region_id: region.id, id: community.id } }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      it 'does NOY allow access' do
        expect{ put :update, params: { region_id: region.id, id: community.slug, community: { name: 'Updated Name' } } }.to raise_error('Not Found')
      end
    end
  end
end
