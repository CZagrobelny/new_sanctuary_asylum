require 'rails_helper'

RSpec.describe Sanctuary, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :leader_name }
  it { is_expected.to validate_presence_of :community_id }
  it { is_expected.to belong_to :community }
end
