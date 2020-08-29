require 'rails_helper'

RSpec.describe Draft, type: :model do
  describe '#status_string' do
    let(:draft) { create(:draft, status: status) }
    subject { draft.status_string }

    context 'draft has no status' do
      let(:status) { nil }

      it 'returns the default message' do
        expect(subject).to eq(Draft::NO_STATUS_MESSAGE)
      end
    end

    context 'draft has a status' do
      let(:status) { 'in_progress' }

      it 'returns the status in string form' do
        expect(subject).to eq('In progress')
      end
    end
  end
end
