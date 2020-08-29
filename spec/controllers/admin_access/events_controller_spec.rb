require 'rails_helper'

RSpec.describe Admin::EventsController, type: :controller do
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing events in the user's community"  do
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
        let(:event) { build :event, community: community, location: create(:location) }
        it 'allows access' do
          event_count = Event.count
          post :create, params: { community_slug: community.slug, event: event.attributes }
          expect(Event.count).to eq event_count + 1
        end
      end

      describe 'GET #edit' do
        let(:event) { create :event, community: community }
        it 'allows access' do
          get :edit, params: { community_slug: community.slug, id: event.id }
          expect(response.successful?).to eq true
        end
      end

      describe 'PUT #update' do
        let!(:event) { create :event, community: community }
        it 'allows access' do
          event_attributes = event.attributes
          event_attributes['title'] = 'new name'
          put :update, params: { community_slug: community.slug, id: event.id, event: event_attributes }
          expect(event.reload.title).to eq 'new name'
        end
      end

      describe 'DELETE #destroy' do
        let!(:event) { create :event, community: community }
        it 'allows access' do
          event_count = Event.count
          delete :destroy, params: { community_slug: community.slug, id: event.id }
          expect(Event.count).to eq event_count - 1
        end
      end

      describe 'GET #attendance' do
        let!(:event) { create :event, community: community }
        it 'allows access' do
          get :attendance, params: { community_slug: community.slug, id: event.id }
          expect(response.successful?).to eq true
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
        let(:event) { build :event, community: community }
        it 'does NOT allow access' do
          expect { post :create, params: { community_slug: community.slug, event: event.attributes } }.to raise_error('Not Found')
        end
      end

      describe 'GET #edit' do
        let(:event) { create :event, community: community }
        it 'does NOT allow access' do
          expect { get :edit, params: { community_slug: community.slug, id: event.id } }.to raise_error('Not Found')
        end
      end

      describe 'PUT #update' do
        let!(:event) { create :event, community: community }
        it 'does NOT allow access' do
          expect { put :update, params: { community_slug: community.slug, id: event.id, event: event.attributes } }.to raise_error('Not Found')
        end
      end

      describe 'DELETE #destroy' do
        let!(:event) { create :event, community: community }
        it 'does NOT allow access' do
          expect { delete :destroy, params: { community_slug: community.slug, id: event.id } }.to raise_error('Not Found')
        end
      end

      describe 'GET #attendance' do
        let!(:event) { create :event, community: community }
        it 'allows access' do
          expect { get :attendance, params: { community_slug: community.slug, id: event.id } }.to raise_error('Not Found')
        end
      end
    end
  end

  describe "managing events NOT in the user's community"  do
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
      let(:event) { build :event, community: other_community }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, event: event.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:event) { create :event, community: other_community }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, id: event.id } }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:event) { create :event, community: other_community }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, id: event.id, event: event.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'DELETE #destroy' do
      let!(:event) { create :event, community: other_community }
      it 'does NOT allow access' do
        expect { delete :destroy, params: { community_slug: other_community.slug, id: event.id } }.to raise_error('Not Found')
      end
    end

    describe 'GET #attendance' do
      let!(:event) { create :event, community: other_community }
      it 'allows access' do
        expect { get :attendance, params: { community_slug: other_community.slug, id: event.id } }.to raise_error('Not Found')
      end
    end
  end
end
