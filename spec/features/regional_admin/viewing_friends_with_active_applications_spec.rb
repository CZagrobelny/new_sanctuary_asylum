require 'rails_helper'

RSpec.describe 'Regional Admin views friends with active applications', type: :feature do

  let(:regional_admin) { create :user, :regional_admin, community: community }
  let(:community) { create :community }
  let(:region) { community.region }
  let!(:friend) { create :friend, community: community, region: region }

  before do
    login_as(regional_admin)
  end

  describe 'friend with at least one active application' do
    let!(:application) { create :application, friend: friend, status: 'review_requested' }
    let!(:remote_clinic_lawyer) { create :user, :remote_clinic_lawyer }
    let!(:user_friend_association) { create :user_friend_association, user: remote_clinic_lawyer, friend: friend, remote: true }

    describe "without other applications" do
      it 'closes an application and destroys the remote user_friend_associations' do
        visit regional_admin_region_friend_path(region, friend)

        category = application.category.titlecase
        click_on("Close #{category} Application")

        success_text = 'Application closed and assigned remote clinic lawyers removed.'
        expect(page).to have_content(success_text)

        expect(friend.reload.users).to be_empty

        expect(application.reload.status).to eq('closed')
      end
    end

    describe "with other applications" do
      let!(:other_application) { create :application, friend: friend, status: 'review_requested', category: "sijs" }

      it 'closes an application and does not destroy the remote user_friend_associations' do
        visit regional_admin_region_friend_path(region, friend)

        category = application.category.titlecase
        click_on("Close #{category} Application")

        expect(page).to have_link(friend.name)

        success_text = 'Application closed.'
        expect(page).to have_content(success_text)

        expect(friend.reload.users).to match_array([remote_clinic_lawyer])

        expect(application.reload.status).to eq('closed')
      end
    end
  end
end
