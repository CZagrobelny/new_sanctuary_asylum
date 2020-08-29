require 'rails_helper'

RSpec.describe UserFriendAssociation, type: :model do
  describe 'creates remote relationship' do
    let(:friend) { create(:friend) }
    let(:user) { create(:user, :remote_clinic_lawyer) }
    let(:mailer) { double(deliver_now: true) }

    it 'sends email to remote lawyer' do
      expect(FriendshipAssignmentMailer).to receive(:send_assignment_email).once.and_return(mailer)
      UserFriendAssociation.create(user: user, friend: friend, remote: true)
    end
  end
end
