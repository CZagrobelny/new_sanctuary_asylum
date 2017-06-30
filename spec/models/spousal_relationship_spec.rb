require 'rails_helper'

RSpec.describe SpousalRelationship, type: :model do
  subject(:spousal_relationship) { build :spousal_relationship }

  it { should validate_presence_of(:friend_id) }
  it { should validate_presence_of(:spouse_id) }
end