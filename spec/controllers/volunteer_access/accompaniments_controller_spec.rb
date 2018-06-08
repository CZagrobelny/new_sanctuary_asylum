require 'rails_helper'

RSpec.describe AccompanimentsController, type: :controller do
  let(:volunteer) { create :user, :volunteer, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(volunteer)
  end

  describe "accessing a user's accompaniments" do
    let(:activity) { create :activity, region: community.region }

    context 'when the community is primary' do
      let(:community) { create :community, :primary }
      describe 'PUT #update' do
        let!(:accompaniment) { create :accompaniment, activity: activity, user: volunteer }
        it 'allows access' do
          accompaniment.availability_notes = 'new availability_notes'
          put :update, params: { community_slug: community.slug, id: accompaniment.id, accompaniment: accompaniment.attributes }
          expect(accompaniment.availability_notes).to eq 'new availability_notes'
        end
      end
    end

    context 'when the community is NOT primary' do
      let(:community) { create :community }
      describe 'POST #create' do
        let(:accompaniment) { build :accompaniment, activity: activity }
        it 'does NOT allow access' do
          expect { post :create, params: { community_slug: community.slug, accompaniment: accompaniment.attributes } }.to raise_error('Not Found')
        end
      end

      describe 'PUT #update' do
        let!(:accompaniment) { create :accompaniment, activity: activity, user: volunteer }
        it 'does NOT allow access' do
          accompaniment.availability_notes = 'new availability_notes'
          expect { put :update, params: { community_slug: community.slug, id: accompaniment.id, accompaniment: accompaniment.attributes } }.to raise_error('Not Found')
        end
      end
    end
  end
end
