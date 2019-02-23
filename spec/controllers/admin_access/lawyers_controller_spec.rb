require 'rails_helper'

RSpec.describe Admin::LawyersController, type: :controller do
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing lawyers in the user's community"  do
    let!(:community) { create :community }
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
      let(:lawyer) { build :lawyer, region: community.region }
      it 'allows access' do
        lawyer_count = Lawyer.count
        post :create, params: { community_slug: community.slug, lawyer: lawyer.attributes }
        expect(Lawyer.count).to eq lawyer_count + 1
      end
    end

    describe 'GET #edit' do
      let(:lawyer) { create :lawyer, region: community.region }
      it 'allows access' do
        get :edit, params: { community_slug: community.slug, id: lawyer.id }
        expect(response.successful?).to eq true
      end
    end

    describe 'PUT #update' do
      let!(:lawyer) { create :lawyer, region: community.region }
      it 'allows access' do
        lawyer.first_name = 'new name'
        put :update, params: { community_slug: community.slug, id: lawyer.id, lawyer: lawyer.attributes }
        expect(lawyer.first_name).to eq 'new name'
      end
    end
  end

  describe "managing lawyers NOT in the user's community"  do
    let!(:community) { create :community, :primary }
    let!(:other_community) { create :community, :primary }
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
      let(:lawyer) { build :lawyer, region: other_community.region }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, lawyer: lawyer.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:lawyer) { create :lawyer, region: other_community.region }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, id: lawyer.id } }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:lawyer) { create :lawyer, region: other_community.region }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, id: lawyer.id, lawyer: lawyer.attributes } }.to raise_error('Not Found')
      end
    end
  end
end