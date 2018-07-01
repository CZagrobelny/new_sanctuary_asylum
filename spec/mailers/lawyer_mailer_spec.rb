require 'rails_helper'

RSpec.describe LawyerMailer, type: :mailer do

  describe 'review_needed_email(draft)' do
    let(:draft) { create :draft, status: :in_review }
    let(:user) { create :user, volunteer_type: "lawyer" }
    let(:non_remote_clinic_user) { create :user, volunteer_type: "spanish_interpreter",
                                          role: "volunteer" }


    subject(:mail) { LawyerMailer.review_needed_email(draft)}

    before do
      UserFriendAssociation.create!(friend_id: draft.friend.id,
                                    user_id: user.id,
                                    remote: true)
      UserFriendAssociation.create!(friend_id: draft.friend.id,
                                    user_id: user.id)
    end

    it 'emails the lawyers' do
      expect(mail.to).to eq draft.friend.remote_clinic_lawyers.map(&:email)
    end

    it 'renders the body' do
      expect(mail.body.raw_source).to eq "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review."
    end

    it 'does not email other people' do
      expect(mail.to).not_to include non_remote_clinic_user.email
    end
  end
end
