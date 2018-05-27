require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to :location }
  it { is_expected.to belong_to :community }

  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:location_id) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:community_id) }
end
