require 'rails_helper'

RSpec.describe Detention, type: :model do
  subject(:detention) { build :detention, location: create(:location), friend: create(:friend) }

  describe '#display_case_status' do
    subject { detention.display_case_status }

    context 'no case status' do
      before do
        detention.update!(case_status: nil)
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'case status is other' do
      other_case_status = 'test'

      before do
        detention.update!(case_status: 'other', other_case_status: other_case_status)
      end

      it 'returns the other case status' do
        expect(subject).to eq(other_case_status)
      end
    end

    context 'case status is not other' do
      it 'returns the titleized case status' do
        expect(subject).to eq(detention.case_status.titlecase)
      end
    end
  end
end
