require 'rails_helper'

RSpec.describe Admin::SanctuariesController, type: :controller do
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing sanctuaries in the user's community"  do
    let!(:community) { create :community, :primary }
    context 'when the community is primary' do
      describe 'GET #index' do
        it 'allows access' do
          get :index, params: { community_slug: community.slug }
          expect(response.success?).to eq true
        end
      end

      describe 'GET #new' do
        it 'allows access' do
          get :new, params: { community_slug: community.slug }
          expect(response.success?).to eq true
        end
      end

      describe 'POST #create' do
        let(:sanctuary) { build :sanctuary, community: community }
        it 'allows access' do
          sanctuary_count = Sanctuary.count
          post :create, params: { community_slug: community.slug, sanctuary: sanctuary.attributes }
          expect(Sanctuary.count).to eq sanctuary_count + 1
        end
      end

      describe 'GET #edit' do
        let(:sanctuary) { create :sanctuary, community: community }
        it 'allows access' do
          get :edit, params: { community_slug: community.slug, id: sanctuary.id }
          expect(response.success?).to eq true
        end
      end

      describe 'PUT #update' do
        let!(:sanctuary) { create :sanctuary, community: community }
        it 'allows access' do
          sanctuary.name = 'new name'
          put :update, params: { community_slug: community.slug, id: sanctuary.id, sanctuary: sanctuary.attributes }
          expect(sanctuary.name).to eq 'new name'
        end
      end
    end

    context 'when the community is NOT primary' do
      let!(:community) { create :community }
      describe 'GET #index' do
        it 'allows access' do
          get :index, params: { community_slug: community.slug }
          expect(response.success?).to eq true
        end
      end

      describe 'GET #new' do
        it 'allows access' do
          get :new, params: { community_slug: community.slug }
          expect(response.success?).to eq true
        end
      end

      describe 'POST #create' do
        let(:sanctuary) { build :sanctuary, community: community }
        it 'allows access' do
          sanctuary_count = Sanctuary.count
          post :create, params: { community_slug: community.slug, sanctuary: sanctuary.attributes }
          expect(Sanctuary.count).to eq sanctuary_count + 1
        end
      end

      describe 'GET #edit' do
        let(:sanctuary) { create :sanctuary, community: community }
        it 'allows access' do
          get :edit, params: { community_slug: community.slug, id: sanctuary.id }
          expect(response.success?).to eq true
        end
      end

      describe 'PUT #update' do
        let!(:sanctuary) { create :sanctuary, community: community }
        it 'allows access' do
          sanctuary.name = 'new name'
          put :update, params: { community_slug: community.slug, id: sanctuary.id, sanctuary: sanctuary.attributes }
          expect(sanctuary.name).to eq 'new name'
        end
      end
    end
  end

  describe "managing sanctuaries NOT in the user's community"  do
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
      let(:sanctuary) { build :sanctuary, community: other_community }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, sanctuary: sanctuary.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:sanctuary) { create :sanctuary, community: other_community }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, id: sanctuary.id } }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:sanctuary) { create :sanctuary, community: other_community }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, id: sanctuary.id, sanctuary: sanctuary.attributes } }.to raise_error('Not Found')
      end
    end
  end
end
