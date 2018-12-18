require 'rails_helper'

RSpec.describe Activity, type: :model do

  it { is_expected.to belong_to :friend }
  it { is_expected.to belong_to :judge }
  it { is_expected.to belong_to :location }
  it { is_expected.to belong_to :region }
  it { is_expected.to belong_to :activity_type }

  it { is_expected.to validate_presence_of :friend_id }
  it { is_expected.to validate_presence_of :region_id }
  it { is_expected.to validate_presence_of :occur_at }
  it { is_expected.to validate_presence_of :activity_type_id }

end
