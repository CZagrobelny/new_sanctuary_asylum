require 'rails_helper'

RSpec.describe RegionalAdmin::FriendsController, type: :controller do

  let(:regional_admin) { create :user, :regional_admin, community: community }
  let(:community) { create :community, region: region }
  let(:region) { create :region }
  let(:friend) { create :friend, community: community, region: region }

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
      get :show, params: { region_id: region.id, id: friend.id }
      expect(response.success?).to eq true
    end
  end
end