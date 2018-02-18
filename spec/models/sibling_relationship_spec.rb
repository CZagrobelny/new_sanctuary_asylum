require 'rails_helper'

RSpec.describe SiblingRelationship, type: :model do
  subject(:sibling_relationship) { build :sibling_relationship }

  it { should validate_presence_of(:friend_id) }
  it { should validate_presence_of(:sibling_id) }
end
