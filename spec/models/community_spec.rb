require 'rails_helper'

RSpec.describe Community, type: :model do

  it { is_expected.to belong_to :region }
  it { is_expected.to validate_presence_of :region_id }

end