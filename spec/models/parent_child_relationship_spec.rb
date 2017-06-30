require 'rails_helper'

RSpec.describe ParentChildRelationship, type: :model do
  subject(:parent_child_relationship) { build :parent_child_relationship }

  it { should validate_presence_of(:parent_id) }
  it { should validate_presence_of(:child_id) }
end