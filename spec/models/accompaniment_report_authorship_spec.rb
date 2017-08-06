require 'rails_helper'

RSpec.describe AccompanimentReportAuthorship, type: :model do

  it { is_expected.to belong_to :accompaniment_report }
  it { is_expected.to belong_to :user }

end