require 'rails_helper'

RSpec.describe AccompanimentReport, type: :model do

  it { is_expected.to belong_to :activity }

  it { is_expected.to validate_presence_of :notes }
  it { is_expected.to validate_presence_of :activity_id }

end