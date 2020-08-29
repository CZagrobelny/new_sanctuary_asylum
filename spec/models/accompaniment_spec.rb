require 'rails_helper'

RSpec.describe Accompaniment, type: :model do
  describe '.volunteer_cap_not_exceeded validation' do
    let(:user) { create :user }
    context 'the activity has a volunteer cap' do
      let!(:activity_type) { create :activity_type, :with_cap_3 }
      let!(:activity) { create :activity, activity_type: activity_type }

      context 'there are already 3 accompaniments for the activity' do
        let!(:accompaniments) do
          create_list :accompaniment, 3, user_id: user.id, activity: activity
        end

        let(:new_accompaniment) do
          build :accompaniment, activity: activity.reload, user: user
        end

        it 'does NOT save the accompaniment' do
          activity.activity_type = activity_type
          expect{ new_accompaniment.save }.not_to change(Accompaniment, :count)
        end

        it 'adds an error message to the accompaniment' do
          new_accompaniment.save

          expect(new_accompaniment.errors[:activity])
            .to eq ["can't exceed 3 volunteer accompaniments."]
        end
      end

      context 'there are no accompaniments for the activity' do
        let(:new_accompaniment) do
          build :accompaniment, activity: activity.reload, user: user
        end

        it 'saves the accompaniment' do
          expect{ new_accompaniment.save }
            .to change(Accompaniment, :count).by 1
        end
      end
    end

    context 'the activity does not have a volunteer cap' do
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
