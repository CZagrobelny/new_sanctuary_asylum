require 'rails_helper'

RSpec.describe AccessTimeSlot, type: :model do
  describe '.active' do
    let!(:future_slot) { create(:access_time_slot, start_time: 1.hour.from_now, end_time: 2.hours.from_now) }
    let!(:current_slot) { create(:access_time_slot, start_time: 1.hour.ago, end_time: 1.hour.from_now) }
    let!(:past_slot) { create(:access_time_slot, start_time: 2.hours.ago, end_time: 1.hour.ago) }
    let!(:current_deactivated_slot) { create(:access_time_slot, start_time: 1.hour.ago, end_time: 1.hour.from_now,
                                             deactivated: true) }

    specify { expect(AccessTimeSlot.active).to contain_exactly(current_slot) }
  end
end
