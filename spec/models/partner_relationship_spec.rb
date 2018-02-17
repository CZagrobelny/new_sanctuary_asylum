require 'rails_helper'

RSpec.describe PartnerRelationship, type: :model do
  subject(:partner_relationship) { build :partner_relationship }

  it { should validate_presence_of(:friend_id) }
  it { should validate_presence_of(:partner_id) }
end
