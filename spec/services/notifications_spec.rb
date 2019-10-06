require 'rails_helper'

RSpec.describe Notification do

  describe '.draft_for_review(draft: draft)' do
    context 'the friend has a lawyer' do
      let(:draft) { create :draft, status: :in_review }
      let(:user) { create :user }


      context 'the friend has a remote lawyer' do
        before do
          UserFriendAssociation.create!(friend_id: draft.friend.id,
                                        user_id: user.id,
                                        remote: true)
        end

        it 'notifies the lawyer' do
          expect(ReviewMailer)
            .to receive_message_chain(:review_needed_email, :deliver_now)
              .and_return(double('ReviewMailer', deliver: true))

          Notification.draft_for_review(draft: draft)
        end
      end

      context 'the friend does not have a lawyer' do
        it 'notifies the regional admin' do
          expect(ReviewMailer)
            .to receive_message_chain(:lawyer_assignment_needed_email, :deliver_now)
              .and_return(double('ReviewMailer', deliver: true))

          Notification.draft_for_review(draft: draft)
        end
      end

    end
  end
end
