require 'rails_helper'

RSpec.describe Admin::ReportsController, type: :controller do
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "generating reports in the user's community" do
    context 'when the community is primary' do
      let(:community) { create :community, :primary }

      describe 'GET #new' do
        it 'allows access' do
          get :new, params: { community_slug: community.slug }
          expect(response.successful?).to eq true
        end
      end

      describe 'POST #create' do
        it 'allows access' do
          post :create, params: { community_slug: community.slug, report: { start_date: 1.week.ago, end_date: Time.now, type: 'event' } }
          expect(response.successful?).to eq true
        end
      end
    end

    context 'when the community is NOT primary' do
      let(:community) { create :community }
      describe 'GET #new' do
        it 'does NOT allow access' do
          expect { get :new, params: { community_slug: community.slug } }.to raise_error('Not Found')
        end
      end

      describe 'POST #create' do
        it 'does NOT allow access' do
          expect { post :create, params: { community_slug: community.slug, report: { start_date: 1.week.ago, end_date: Time.now, type: 'event' } } }.to raise_error('Not Found')
        end
      end
    end
  end

  describe "generating reports NOT in the user's community" do
    let(:community) { create :community }
    let(:other_community) { create :community }
    describe 'GET #new' do
      it 'does NOT allow access' do
        expect { get :new, params: { community_slug: other_community.slug } }.to raise_error('Not Found')
      end
    end

    describe 'POST #create' do
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, report: { start_date: 1.week.ago, end_date: Time.now, type: 'event' } } }.to raise_error('Not Found')
      end
    end
  end
end

