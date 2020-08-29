require 'rails_helper'

RSpec.describe Activity, type: :model do
  let(:friend) { create(:friend) }
  let(:region) { friend.region }
  let(:activity_type) { create(:activity_type) }

  describe 'validations' do
    context 'when the occur at date is present' do
      let(:activity) { build :activity, friend: friend, region: region, activity_type: activity_type, occur_at: Time.now }
      it 'is valid' do
        expect(activity).to be_valid
      end
    end

    context 'when only the tbd is present' do
      let(:activity) { build :activity, friend: friend, region: region, activity_type: activity_type, occur_at: nil, occur_at_tbd: true }
      it 'is valid' do
        expect(activity).to be_valid
      end
    end

    context 'when only the control_date is present' do
      let(:activity) { build :activity, friend: friend, region: region, activity_type: activity_type, control_date: Time.now, occur_at: nil }
      it 'is valid' do
        expect(activity).to be_valid
      end
    end

    context 'when saving without occur at, control_date, or tbd' do
      let(:activity) { build :activity, friend: friend, region: region, activity_type: activity_type, occur_at: nil }
      it 'has the right error' do
        activity.save
        expect(activity.errors.messages[:base]).to eq ['Activity needs either an occur at date, a control date, or TBD set to true']
      end
    end

    context 'when saving with occur at, control_date, and tbd' do
      let(:activity) { build :activity, friend: friend, region: region, activity_type: activity_type, control_date: Time.now, occur_at_tbd: true }
      it 'clears out the control_date and occur_at_tbd' do
        activity.save
        expect(activity.control_date).to eq nil
        expect(activity.occur_at_tbd).to eq false
      end
    end

    context 'when saving without occur at, with control_date, and tbd' do
      time = Time.now
      let(:activity) { build :activity, friend: friend, region: region, activity_type: activity_type, occur_at: nil, control_date: time, occur_at_tbd: true }
      it 'clears out the control_date and occur_at_tbd' do
        activity.save
        expect(activity.control_date).to eq time
        expect(activity.occur_at_tbd).to eq false
      end
    end
  end
end
