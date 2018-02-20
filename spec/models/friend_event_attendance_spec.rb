require 'rails_helper'

RSpec.describe FriendEventAttendance, type: :model do

  it { is_expected.to belong_to :event }
  it { is_expected.to belong_to :friend }

  describe 'validations' do
    subject { FactoryGirl.create(:friend_event_attendance) }

    it { is_expected.to validate_presence_of :event_id }
    it { is_expected.to validate_presence_of :friend_id }
    it { is_expected.to validate_uniqueness_of(:friend_id).scoped_to(:event_id) }
  end
  
end
