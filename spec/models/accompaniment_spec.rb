require 'rails_helper'

RSpec.describe Accompaniment, type: :model do

  it { is_expected.to belong_to :activity }
  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :activity_id }

end
