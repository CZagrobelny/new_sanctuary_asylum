require 'rails_helper'

RSpec.describe UserRegion, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :region }

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :region_id }
end
