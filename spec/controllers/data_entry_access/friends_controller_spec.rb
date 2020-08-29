require 'rails_helper'

RSpec.describe Admin::FriendsController, type: :controller do
  let(:data_entry_user) { create :user, role: 'data_entry' }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(data_entry_user)
  end

  describe 'viewing Friends#index'  do
    context 'when the user has an active access_time_slot' do
      before do
        AccessTimeSlot.create!(grantee_id: data_entry_user.id,
          grantor_id: create(:user, role: 'admin', community: data_entry_user.community).id,
          community_id: data_entry_user.community.id,
          use: 'data_entry',
          start_time: 1.hour.ago,
          end_time: 1.hour.from_now
        )
      end

      describe 'GET #index' do
        it 'allows access' do
          get :index, params: { community_slug: data_entry_user.community.slug }
          expect(response.successful?).to eq true
        end
      end
    end

    context 'when the user does NOT have an active access_time_slot' do
      describe 'GET #index' do
        it 'does NOT allow access' do
          expect { get :index, params: { community_slug: data_entry_user.community.slug } }.to raise_error('Not Found')
        end
      end
    end
  end
end
