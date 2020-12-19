require 'rails_helper'

RSpec.describe ReviewMailer, type: :mailer do
  describe 'review_added_email(review)' do
    let(:community) { create :community }
    let(:region) { community.region }
    let(:draft) { create :draft, status: :review_added, friend: friend }
    let(:review) { create :review, draft: draft }
    let(:friend) { create :friend, community: community, region: region }
    let!(:volunteer) { create :user, community: community }
    let!(:community_admin) { create :user, :community_admin, community: community }
    let!(:regional_admin) { create :user, :regional_admin, community: community }

    subject(:mail) { ReviewMailer.review_added_email(review)}

    before do
      UserFriendAssociation.create!(friend_id: friend.id,
                                    user_id: volunteer.id)
    end

    it 'emails the community volunteers associated with the friend' do
      expect(mail.to).to eq [volunteer.email]
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
      expect(mail.html_part.body.raw_source).to include "#{friend.first_name}'s #{draft.application.category} application draft has recieved a review."
      expect(mail.text_part.body.raw_source).to include "#{friend.first_name}'s #{draft.application.category} application draft has recieved a review."
    end
  end

  describe 'draft_approved_email(draft)' do
    let(:community) { create :community }
    let(:region) { community.region }
    let(:application) { create :application, friend: friend }
    let(:friend) { create :friend, community: community, region: region }
    let!(:volunteer) { create :user, community: community }
    let!(:community_admin) { create :user, :community_admin, community: community }
    let!(:regional_admin) { create :user, :regional_admin, community: community }

    subject(:mail) { ReviewMailer.application_approved_email(application)}

    before do
      UserFriendAssociation.create!(friend_id: friend.id,
                                    user_id: volunteer.id)
    end

    it 'emails the community volunteers associated with the friend' do
      expect(mail.to).to eq [volunteer.email]
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
      expect(mail.html_part.body.raw_source).to include "#{friend.first_name}'s #{application.category} application has an approved draft."
      expect(mail.text_part.body.raw_source).to include "#{friend.first_name}'s #{application.category} application has an approved draft."
    end
  end
end
