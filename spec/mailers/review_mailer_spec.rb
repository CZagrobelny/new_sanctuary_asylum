require 'rails_helper'

RSpec.describe ReviewMailer, type: :mailer do

  describe 'review_needed_email(draft)' do
    let(:draft) { create :draft, status: :in_review }
    let(:user) { create :user, volunteer_type: "lawyer" }
    let(:non_remote_clinic_user) { create :user, volunteer_type: "spanish_interpreter",
                                          role: "volunteer" }


    subject(:mail) { ReviewMailer.review_needed_email(draft)}

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

  describe 'lawyer_assignment_needed_email(draft)' do
    let(:draft) { create :draft, status: :in_review }
    let(:admin_user) { create :user, volunteer_type: "spanish_interpreter",
                                     role: "admin" }
    let(:non_admin_user) { create :user, volunteer_type: "spanish_interpreter",
                                         role: "volunteer" }

    subject(:mail) { ReviewMailer.lawyer_assignment_needed_email(draft)}

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
      expect(mail.body.raw_source).to eq "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review and is awaiting lawyer assignment."
    end

    it 'does not email non admins' do
      expect(mail.to).not_to eq non_admin_user.email
    end
  end

  describe 'changes_requested(review)' do
    let(:community) { create :community }
    let(:region) { community.region }
    let(:draft) { create :draft, status: :changes_requested, friend: friend }
    let(:review) { create :review, draft: draft }
    let(:friend) { create :friend, community: community, region: region }
    let!(:volunteer) { create :user, volunteer_type: 'english_speaking', community: community }
    let!(:community_admin) { create :user, :community_admin, community: community }

    subject(:mail) { ReviewMailer.changes_requested(review)}

    before do
      UserFriendAssociation.create!(friend_id: friend.id,
                                    user_id: volunteer.id)
    end

    it 'emails the community admins and community volunteers associated with the friend' do
      expect(mail.to).to eq [community_admin.email, volunteer.email]
    end

    it 'renders the body' do
      expect(mail.body.raw_source).to eq "#{friend.first_name}'s #{draft.application.category} application draft has recieved a review: #{community_friend_draft_review_url(friend.community.slug, friend, draft, review)}."
    end
  end
end
