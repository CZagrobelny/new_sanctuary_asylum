require 'rails_helper'

RSpec.describe Judge, type: :model do

  it { is_expected.to have_many :activities }
  it { is_expected.to belong_to :region }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :region_id }

end
