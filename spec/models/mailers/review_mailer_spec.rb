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

    it 'does not email other people' do
      expect(mail.to).not_to include non_remote_clinic_user.email
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq 2
      expect(mail.body.parts.collect(&:content_type)).to include "text/html; charset=UTF-8"
      expect(mail.body.parts.collect(&:content_type)).to include "text/plain; charset=UTF-8"
    end

    it 'renders the body' do
      expect(mail.html_part.body.raw_source).to include "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review: <a href=\"#{remote_clinic_friend_url(draft.friend)}\">#{remote_clinic_friend_url(draft.friend)}</a>"
      expect(mail.text_part.body.raw_source).to include "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review: #{remote_clinic_friend_url(draft.friend)}"
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

    it 'does not email non admins' do
      expect(mail.to).not_to eq non_admin_user.email
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq 2
      expect(mail.body.parts.collect(&:content_type)).to include "text/html; charset=UTF-8"
      expect(mail.body.parts.collect(&:content_type)).to include "text/plain; charset=UTF-8"
    end

    it 'renders the body' do
      expect(mail.html_part.body.raw_source).to include "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review and is awaiting lawyer assignment: <a href=\"#{regional_admin_region_friend_url(draft.friend.region, draft.friend)}\">#{regional_admin_region_friend_url(draft.friend.region, draft.friend)}</a>"
      expect(mail.text_part.body.raw_source).to include "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review and is awaiting lawyer assignment: #{regional_admin_region_friend_url(draft.friend.region, draft.friend)}"
    end
  end

  describe 'changes_requested_email(review)' do
    let(:community) { create :community }
    let(:region) { community.region }
    let(:draft) { create :draft, status: :changes_requested, friend: friend }
    let(:review) { create :review, draft: draft }
    let(:friend) { create :friend, community: community, region: region }
    let!(:volunteer) { create :user, volunteer_type: 'english_speaking', community: community }
    let!(:community_admin) { create :user, :community_admin, community: community }
    let!(:regional_admin) { create :user, :regional_admin, community: community }

    subject(:mail) { ReviewMailer.changes_requested_email(review)}

    before do
      UserFriendAssociation.create!(friend_id: friend.id,
                                    user_id: volunteer.id)
    end

    it 'emails the regional admins and community volunteers associated with the friend' do
      expect(mail.to).to eq [regional_admin.email, volunteer.email]
    end

    it 'does not email community admins' do
      expect(mail.to).not_to eq community_admin.email
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq 2
      expect(mail.body.parts.collect(&:content_type)).to include "text/html; charset=UTF-8"
      expect(mail.body.parts.collect(&:content_type)).to include "text/plain; charset=UTF-8"
    end

    it 'renders the body' do
      expect(mail.html_part.body.raw_source).to include "#{friend.first_name}'s #{draft.application.category} application draft has recieved a review: <a href=\"#{community_friend_url(friend.community.slug, friend)}\">#{community_friend_url(friend.community.slug, friend)}</a>"
      expect(mail.text_part.body.raw_source).to include "#{friend.first_name}'s #{draft.application.category} application draft has recieved a review: #{community_friend_url(friend.community.slug, friend)}"
    end
  end

  describe 'draft_approved_email(draft)' do
    let(:community) { create :community }
    let(:region) { community.region }
    let(:application) { create :application, friend: friend }
    let(:friend) { create :friend, community: community, region: region }
    let!(:volunteer) { create :user, volunteer_type: 'english_speaking', community: community }
    let!(:community_admin) { create :user, :community_admin, community: community }
    let!(:regional_admin) { create :user, :regional_admin, community: community }

    subject(:mail) { ReviewMailer.application_approved_email(application)}

    before do
      UserFriendAssociation.create!(friend_id: friend.id,
                                    user_id: volunteer.id)
    end

    it 'emails the regional admins and community volunteers associated with the friend' do
      expect(mail.to).to eq [regional_admin.email, volunteer.email]
    end

    it 'does not email community admins' do
      expect(mail.to).not_to eq community_admin.email
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq 2
      expect(mail.body.parts.collect(&:content_type)).to include "text/html; charset=UTF-8"
      expect(mail.body.parts.collect(&:content_type)).to include "text/plain; charset=UTF-8"
    end

    it 'renders the body' do
      expect(mail.html_part.body.raw_source).to include "#{friend.first_name}'s #{application.category} application has an approved draft: <a href=\"#{community_friend_url(friend.community.slug, friend)}\">#{community_friend_url(friend.community.slug, friend)}</a>"
      expect(mail.text_part.body.raw_source).to include "#{friend.first_name}'s #{application.category} application has an approved draft: #{community_friend_url(friend.community.slug, friend)}"
    end
  end
end
