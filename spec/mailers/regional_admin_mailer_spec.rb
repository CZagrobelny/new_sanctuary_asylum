require 'rails_helper'

RSpec.describe RegionalAdminMailer, type: :mailer do

  describe 'review_needed_email(draft)' do
    let(:draft) { create :draft, status: :in_review }
    let(:admin_user) { create :user, volunteer_type: "spanish_interpreter",
                                     role: "admin" }
    let(:non_admin_user) { create :user, volunteer_type: "spanish_interpreter",
                                         role: "volunteer" }

    subject(:mail) { RegionalAdminMailer.review_needed_email(draft)}

    before do
      UserFriendAssociation.create!(friend_id: draft.friend.id,
                                    user_id: admin_user.id,
                                    remote: true)
      UserFriendAssociation.create!(friend_id: draft.friend.id,
                                    user_id: non_admin_user.id,
                                    remote: true)
    end

    it 'emails admins' do
      expect(mail.to).to eq draft.friend.region.regional_admins.map(&:email)
    end

    it 'renders the body' do
      expect(mail.body.raw_source).to match "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review."
    end

    it 'does not email non admins' do
      expect(mail.to).not_to eq non_admin_user.email
    end
  end
end
