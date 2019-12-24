require 'rails_helper'

RSpec.describe Admin::CohortsController, type: :controller do
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing cohorts in the user's community"  do
    let!(:community) { create :community }
    let(:cohort_attributes) { { community_id: community.id, color: 'color', start_date: Date.today } }
    let(:cohort) { Cohort.create(cohort_attributes) }

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
      it 'allows access' do
        cohort_count = Cohort.count
        post :create, params: { community_slug: community.slug, cohort: cohort_attributes }
        expect(Cohort.count).to eq cohort_count + 1
      end
    end

    describe 'GET #edit' do
      it 'allows access' do
        get :edit, params: { community_slug: community.slug, id: cohort.id }
        expect(response.successful?).to eq true
      end
    end

    describe 'GET #assignment' do
      it 'allows access' do
        get :assignment, params: { community_slug: community.slug, id: cohort.id }
        expect(response.successful?).to eq true
      end
    end

    describe 'PUT #update' do
      it 'allows access' do
        cohort_attributes = cohort.attributes
        cohort_attributes['color'] = 'new color'
        put :update, params: { community_slug: community.slug, id: cohort.id, cohort: cohort_attributes }
        expect(cohort.reload.color).to eq 'new color'
      end
    end
  end

  describe "managing cohorts NOT in the user's community"  do
    let!(:community) { create :community, :primary }
    let!(:other_community) { create :community, :primary }
    let(:other_community_cohort_attributes) { { community_id: community.id, color: 'color', start_date: Date.today } }
    let(:other_community_cohort) { Cohort.create(other_community_cohort_attributes) }

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
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, cohort: other_community_cohort_attributes } }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, id: other_community_cohort.id } }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, id: other_community_cohort.id, cohort: other_community_cohort.attributes } }.to raise_error('Not Found')
      end
    end
  end
end