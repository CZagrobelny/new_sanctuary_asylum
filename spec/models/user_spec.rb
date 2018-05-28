require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build :user }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:community_id) }
  it { should belong_to :community }
end