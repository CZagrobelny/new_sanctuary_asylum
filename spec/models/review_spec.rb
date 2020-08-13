require 'rails_helper'

RSpec.describe Review, type: :model do
  subject { create(:review) }

  it { should validate_uniqueness_of(:user_id).scoped_to(:draft_id).with_message(Review::VALIDATION_MESSAGE) }
  it { should belong_to(:user) }
  it { should belong_to(:draft) }

  describe '#authored_by?(user)' do
    let(:review) { create(:review, user: author) }
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    subject { review.authored_by?(user)}

    context 'user is the author' do
      let(:user) { author }

      it 'returns true' do
        expect(subject).to eq true
      end
    end

    context 'user is not the author' do
      let(:user) { not_author }

      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end
end
