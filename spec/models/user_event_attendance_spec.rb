require 'rails_helper'

RSpec.describe UserEventAttendance, type: :model do

  it { is_expected.to belong_to :event }
  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :event_id }
  it { is_expected.to validate_presence_of :user_id }

end