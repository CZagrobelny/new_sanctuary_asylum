require 'rails_helper'

RSpec.describe RegionalAdmin::CommunitiesController, type: :controller do

  let(:regional_admin) { create :user, :regional_admin, community: community }
  let(:community) { create :community, region: region }
  let(:region) { create :region }

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
    it 'returns a successful page' do
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
