require 'rails_helper'

RSpec.describe Admin::JudgesController, type: :controller do
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "managing judges in the user's community"  do
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
        let(:judge) { build :judge, region: community.region }
        it 'allows access' do
          judge_count = Judge.count
          post :create, params: { community_slug: community.slug, judge: judge.attributes }
          expect(Judge.count).to eq judge_count + 1
        end
      end

      describe 'GET #edit' do
        let(:judge) { create :judge, region: community.region }
        it 'allows access' do
          get :edit, params: { community_slug: community.slug, id: judge.id }
          expect(response.successful?).to eq true
        end
      end

      describe 'PUT #update' do
        let!(:judge) { create :judge, region: community.region }
        it 'allows access' do
          judge_attributes = judge.attributes
          judge_attributes['first_name'] = 'new name'
          put :update, params: { community_slug: community.slug, id: judge.id, judge: judge_attributes }
          expect(judge.reload.first_name).to eq 'new name'
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
        let(:judge) { build :judge, region: community.region }
        it 'does NOT allow access' do
          expect { post :create, params: { community_slug: community.slug, judge: judge.attributes } }.to raise_error('Not Found')
        end
      end

      describe 'GET #edit' do
        let(:judge) { create :judge, region: community.region }
        it 'does NOT allow access' do
          expect { get :edit, params: { community_slug: community.slug, id: judge.id } }.to raise_error('Not Found')
        end
      end

      describe 'PUT #update' do
        let!(:judge) { create :judge, region: community.region }
        it 'does NOT allow access' do
          expect { put :update, params: { community_slug: community.slug, id: judge.id, judge: judge.attributes } }.to raise_error('Not Found')
        end
      end
    end
  end

  describe "managing judges NOT in the user's community"  do
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
      let(:judge) { build :judge, region: other_community.region }
      it 'does NOT allow access' do
        expect { post :create, params: { community_slug: other_community.slug, judge: judge.attributes } }.to raise_error('Not Found')
      end
    end

    describe 'GET #edit' do
      let(:judge) { create :judge, region: other_community.region }
      it 'does NOT allow access' do
        expect { get :edit, params: { community_slug: other_community.slug, id: judge.id } }.to raise_error('Not Found')
      end
    end

    describe 'PUT #update' do
      let!(:judge) { create :judge, region: other_community.region }
      it 'does NOT allow access' do
        expect { put :update, params: { community_slug: other_community.slug, id: judge.id, judge: judge.attributes } }.to raise_error('Not Found')
      end
    end
  end
end
