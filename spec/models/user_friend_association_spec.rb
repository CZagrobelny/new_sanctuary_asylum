require 'rails_helper'

RSpec.describe UserFriendAssociation, type: :model do
  it { is_expected.to belong_to :friend }
  it { is_expected.to belong_to :user }

  describe 'creates remote relationship' do
    let(:friend) { create(:friend) }
    let(:user) { create(:user, :remote_clinic_lawyer) }
    let(:mailer) { double(deliver_now: true) }

    it 'sends email to remote lawyer' do
      expect(FriendshipAssignmentMailer).to receive(:send_assignment).once.and_return(mailer)
      UserFriendAssociation.create(user: user, friend: friend, remote: true)
    end
  end
end
