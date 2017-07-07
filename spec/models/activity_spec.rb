require 'rails_helper'

RSpec.describe Activity, type: :model do

  it { is_expected.to belong_to :friend }
  it { is_expected.to belong_to :judge }
  it { is_expected.to belong_to :location }

end
