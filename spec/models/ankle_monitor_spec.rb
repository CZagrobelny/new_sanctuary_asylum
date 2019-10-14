require 'rails_helper'

RSpec.describe AnkleMonitor, type: :model do
  it { is_expected.to belong_to :friend }
  it { is_expected.to validate_presence_of :friend_id }
end
