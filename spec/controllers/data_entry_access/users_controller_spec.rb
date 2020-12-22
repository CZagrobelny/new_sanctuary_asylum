require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:community) { create :community }
  let!(:data_entry_user) { create :user, community: community, role: 'data_entry' }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(data_entry_user)
  end

  describe "PUT #update" do
    context 'when the user has an active time slot' do
      let!(:user) {create :user, community: community, role: "admin", first_name: "Elizabeth"}
      before do
        AccessTimeSlot.create!(
          grantee_id: data_entry_user.id,
          grantor_id: user.id,
          community_id: data_entry_user.community.id,
          use: 'data_entry',
          start_time: 1.hour.ago,
          end_time: 1.hour.from_now
        )
      end

      it 'does NOT allow access' do
        user.first_name = "Jane"
        user.role = "data_entry"
        expect { put :update, params: { community_slug: community.slug, id: user.id, user: user.attributes } }.to raise_error('Not Found')
        expect(user.reload.role).to eq "admin"
        expect(user.reload.first_name).to eq "Elizabeth"
      end
    end
  end
end
