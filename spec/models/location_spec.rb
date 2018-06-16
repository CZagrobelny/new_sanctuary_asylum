require 'rails_helper'

RSpec.describe Location, type: :model do

  it { is_expected.to have_many :activities }
  it { is_expected.to have_many :events }
  it { is_expected.to belong_to :region }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :region_id }

end
