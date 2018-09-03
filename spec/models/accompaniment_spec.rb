require 'rails_helper'

RSpec.describe Accompaniment, type: :model do

  it { is_expected.to belong_to :activity }
  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :activity_id }

  describe '.limit_for_family_court validation' do
    let(:user) { create :user }
    context 'the activity is family_court' do
      let!(:activity) { create :activity, :family_court }

      context 'there are already 3 accompaniments for the activity' do
        let!(:accompaniments) do
          create_list :accompaniment, 3, user_id: user.id, activity: activity
        end

        let(:new_accompaniment) do
          build :accompaniment, activity: activity.reload, user: user
        end

        it 'does NOT save the accompaniment' do
          expect{ new_accompaniment.save }.not_to change(Accompaniment, :count)
        end

        it 'adds an error message to the accompaniment' do
          new_accompaniment.save

          expect(new_accompaniment.errors[:activity])
            .to eq ["can't exceed 3 volunteer accompaniments."]
        end
      end

      context 'there are no accompaniments for the activity' do
        let!(:activity) { create :activity, :family_court }

        let(:new_accompaniment) do
          build :accompaniment, activity: activity.reload, user: user
        end

        it 'saves the accompaniment' do
          expect{ new_accompaniment.save }
            .to change(Accompaniment, :count).by 1
        end
      end
    end

    context 'the activity is not family_court' do
      let!(:activity) { create :activity }

      context 'there are already 3 accompaniments for the activity' do
        let!(:accompaniments) do
          create_list :accompaniment, 3, user_id: user.id, activity: activity
        end

         let(:new_accompaniment) do
          build :accompaniment, activity: activity.reload, user: user
        end

        it 'saves the accompaniment' do
          expect{ new_accompaniment.save }.to change(Accompaniment, :count)
        end
      end
    end
  end
end
