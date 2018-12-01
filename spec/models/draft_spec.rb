require 'rails_helper'

RSpec.describe Draft, type: :model do
  it { should validate_presence_of(:pdf_draft) }
  it { should validate_presence_of(:application_id) }
  it { should belong_to(:friend) }
  it { should belong_to(:application) }
  it { should have_many(:user_draft_associations) }
  it { should have_many(:users).through(:user_draft_associations) }
  it { should have_many(:reviews) }

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
