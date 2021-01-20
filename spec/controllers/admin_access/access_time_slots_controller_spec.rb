require 'rails_helper'

RSpec.describe Admin::AccessTimeSlotsController, type: :controller do
  let(:community) { create :community, :primary }
  let(:community_admin) { create :user, :community_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  context 'time slot in the future' do
    let(:time_slot) { create(:access_time_slot, start_time: 1.hour.from_now, end_time: 2.hours.from_now, use: :data_entry) }

    describe 'GET #edit' do
      it 'allows access' do
        get :edit, params: {community_slug: community.slug, id: time_slot.id}
        expect(response).to be_successful
      end
    end

    describe 'PATCH #update' do
      it 'allows access' do
        patch :update, params: {community_slug: community.slug, id: time_slot.id,
                                access_time_slot: {use: :clinic_support}}
        expect(time_slot.reload.use).to eq 'clinic_support'
      end
    end

    describe 'DELETE #destroy' do
      it 'allows access' do
        delete :destroy, params: {community_slug: community.slug, id: time_slot.id}
        expect{ AccessTimeSlot.find(time_slot.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context 'time slot is ongoing now' do
    let(:time_slot) { create(:access_time_slot, start_time: 1.hour.ago, end_time: 1.hour.from_now, use: :data_entry) }

    describe 'GET #edit' do
      it 'does NOT allow access' do
        expect do
          get :edit, params: {community_slug: community.slug, id: time_slot.id}
        end.to raise_error('Not Found')
      end
    end

    describe 'PATCH #update' do
      it 'does NOT allow access' do
        expect do
          patch :update, params: {community_slug: community.slug, id: time_slot.id,
                                  access_time_slot: {use: :clinic_support}}
        end.to raise_error('Not Found')
        expect(time_slot.reload.use).to eq 'data_entry'
      end
    end

    describe 'DELETE #destroy' do
      it 'does NOT allow access' do
        expect do
          delete :destroy, params: {community_slug: community.slug, id: time_slot.id}
        end.to raise_error('Not Found')
        expect(AccessTimeSlot.find(time_slot.id)).to eq time_slot
      end
    end
  end

  context 'time slot is in the past' do
    let(:time_slot) { create(:access_time_slot, start_time: 2.hours.ago, end_time: 1.hour.ago, use: :data_entry) }

    describe 'GET #edit' do
      it 'does NOT allow access' do
        expect do
          get :edit, params: {community_slug: community.slug, id: time_slot.id}
        end.to raise_error('Not Found')
      end
    end

    describe 'PATCH #update' do
      it 'does NOT allow access' do
        expect do
          patch :update, params: {community_slug: community.slug, id: time_slot.id,
                                  access_time_slot: {use: :clinic_support}}
        end.to raise_error('Not Found')
        expect(time_slot.reload.use).to eq 'data_entry'
      end
    end

    describe 'DELETE #destroy' do
      it 'does NOT allow access' do
        expect do
          delete :destroy, params: {community_slug: community.slug, id: time_slot.id}
        end.to raise_error('Not Found')
        expect(AccessTimeSlot.find(time_slot.id)).to eq time_slot
      end
    end
  end
end
