require 'rails_helper'

RSpec.describe Admin::ActivitiesController, type: :controller do
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing activities in the user's community"  do
    let!(:community) { create :community, :primary }
    let!(:activity_type) { create :activity_type, :master_calendar_hearing }
    context 'when the community is primary' do
      describe 'GET #index' do
        it 'allows access' do
          get :index, params: { community_slug: community.slug }
          expect(response.success?).to eq true
        end
      end

      describe 'GET #accompaniments' do
        it 'allows access' do
          get :accompaniments, params: { community_slug: community.slug }
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
        let(:activity) { build :activity, region: community.region }
        it 'allows access' do
          activity_count = Activity.count
          post :create, params: { community_slug: community.slug, activity: activity.attributes }
          expect(Activity.count).to eq activity_count + 1
        end
      end

      describe 'GET #edit' do
        let(:activity) { create :activity, region: community.region }
        it 'allows access' do
          get :edit, params: { community_slug: community.slug, id: activity.id }
          expect(response.success?).to eq true
        end
      end

      describe 'PUT #update' do
        let!(:activity) { create :activity, region: community.region }
        it 'allows access' do
          activity.event = 'individual_hearing'
          put :update, params: { community_slug: community.slug, id: activity.id, activity: activity.attributes }
          expect(activity.event).to eq 'individual_hearing'
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

      describe 'GET #accompaniments' do
        it 'does NOT allow access' do
          expect { get :accompaniments, params: { community_slug: community.slug } }.to raise_error('Not Found')
        end
      end

      describe 'GET #new' do
        it 'does NOT allow access' do
          expect { get :new, params: { community_slug: community.slug } }.to raise_error('Not Found')
        end
      end

      describe 'POST #create' do
        let(:activity) { build :activity, region: community.region }
        it 'does NOT allow access' do
          expect { post :create, params: { community_slug: community.slug, activity: activity.attributes } }.to raise_error('Not Found')
        end
      end

      describe 'GET #edit' do
        let(:activity) { create :activity, region: community.region }
        it 'does NOT allow access' do
          expect { get :edit, params: { community_slug: community.slug, id: activity.id } }.to raise_error('Not Found')
        end
      end

      describe 'PUT #update' do
        let!(:activity) { create :activity, region: community.region }
        it 'does NOT allow access' do
          expect { put :update, params: { community_slug: community.slug, id: activity.id, activity: activity.attributes } }.to raise_error('Not Found')
        end
      end
    end
  end

  describe "managing activities NOT in the user's community"  do
    let!(:community) { create :community, :primary }
    let!(:other_community) { create :community, :primary }
    describe 'GET #index' do
      it 'does NOT allow access' do
        expect { get :index, params: { community_slug: other_community.slug } }.to raise_error('Not Found')
      end
    end

    describe 'GET #accompaniments' do
      it 'does NOT allow access' do
        expect { get :accompaniments, params: { community_slug: other_community.slug } }.to raise_error('Not Found')
      end
    end

    describe 'GET #new' do
      it 'does NOT allow access' do
        expect { get :new, params: { community_slug: other_community.slug } }.to raise_error('Not Found')
      end
    end

    describe 'POST #create' do
      let(:activity) { build :activity, region: other_community.region }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, activity: activity.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:activity) { create :activity, region: other_community.region }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, id: activity.id } }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:activity) { create :activity, region: other_community.region }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, id: activity.id, activity: activity.attributes } }.to raise_error('Not Found')
      end
    end
  end
end
