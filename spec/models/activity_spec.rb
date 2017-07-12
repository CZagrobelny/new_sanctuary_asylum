require 'rails_helper'

RSpec.describe Activity, type: :model do

  it { is_expected.to belong_to :friend }
  it { is_expected.to belong_to :judge }
  it { is_expected.to belong_to :location }

  it { is_expected.to validate_presence_of :friend_id }
  it { is_expected.to validate_presence_of :location_id }
  it { is_expected.to validate_presence_of :occur_at }
  it { is_expected.to validate_presence_of :event }

end
