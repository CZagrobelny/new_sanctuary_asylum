require 'rails_helper'

RSpec.describe Review, type: :model do
  it { should validate_uniqueness_of(:user).scoped_to(:draft).with_message("You already have a review for this draft") }
  it { should belong_to(:user) }
  it { should belong_to(:draft) }

  describe '#authored_by?(user)' do
    let(:review) { create(:review, user: author) }
    subject { review.authored_by?(user)}

    context 'the review has no author' do
      let(:author) { nil }

      context 'user is nil' do
        let(:user) { nil }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'user is present' do
        let(:user) { create(:user) }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

    end

    context 'the review has an author' do
      let(:author) { create(:user) }
      let(:not_author) { create(:user) }

      context 'user is the author' do
        let(:user) { author }

        it 'returns true' do
          expect(subject).to eq true
        end
      end

      context 'user is not the author' do
        let(:user) { not_author }

        it 'returns false' do
          expect(subject).to eq true
        end
      end
    end
  end
end
