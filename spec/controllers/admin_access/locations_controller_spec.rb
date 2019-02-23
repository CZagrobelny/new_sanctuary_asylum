require 'rails_helper'

RSpec.describe Admin::LocationsController, type: :controller do
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing locations in the user's community"  do
    let!(:community) { create :community, :primary }
    context 'when the community is primary' do
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
        let(:location) { build :location, region: community.region }
        it 'allows access' do
          location_count = Location.count
          post :create, params: { community_slug: community.slug, location: location.attributes }
          expect(Location.count).to eq location_count + 1
        end
      end

      describe 'GET #edit' do
        let(:location) { create :location, region: community.region }
        it 'allows access' do
          get :edit, params: { community_slug: community.slug, id: location.id }
          expect(response.successful?).to eq true
        end
      end

      describe 'PUT #update' do
        let!(:location) { create :location, region: community.region }
        it 'allows access' do
          location.name = 'new name'
          put :update, params: { community_slug: community.slug, id: location.id, location: location.attributes }
          expect(location.name).to eq 'new name'
        end
      end
    end

    context 'when the community is NOT primary' do
      let!(:community) { create :community }
      describe 'GET #index' do
        it 'does NOT allow access' do
          expect { get :index, params: { community_slug: community.slug } }.to raise_error('Not Found')
        end
      end

      describe 'GET #new' do
        it 'does NOT allow access' do
          expect { get :new, params: { community_slug: community.slug } }.to raise_error('Not Found')
        end
      end

      describe 'POST #create' do
        let(:location) { build :location, region: community.region }
        it 'does NOT allow access' do
          expect { post :create, params: { community_slug: community.slug, location: location.attributes } }.to raise_error('Not Found')
        end
      end

      describe 'GET #edit' do
        let(:location) { create :location, region: community.region }
        it 'does NOT allow access' do
          expect { get :edit, params: { community_slug: community.slug, id: location.id } }.to raise_error('Not Found')
        end
      end

      describe 'PUT #update' do
        let!(:location) { create :location, region: community.region }
        it 'does NOT allow access' do
          expect { put :update, params: { community_slug: community.slug, id: location.id, location: location.attributes } }.to raise_error('Not Found')
        end
      end
    end
  end

  describe "managing locations NOT in the user's community"  do
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
      let(:location) { build :location, region: other_community.region }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, location: location.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:location) { create :location, region: other_community.region }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, id: location.id } }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:location) { create :location, region: other_community.region }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, id: location.id, location: location.attributes } }.to raise_error('Not Found')
      end
    end
  end
end
