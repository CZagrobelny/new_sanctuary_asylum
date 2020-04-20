require 'rails_helper'

RSpec.describe 'Regional Admin manages drafts', type: :feature do

  let(:regional_admin) { create(:user, :regional_admin, community: community) }
  let(:community) { create :community }
  let(:region) { community.region }
  let(:friend) { create(:friend, community: community, region: region) }
  let(:application) { create(:application, friend: friend, status: 'review_requested') }
  let!(:draft) { create(:draft, friend: friend, application: application) }
  let!(:user_friend_association) { create(:user_friend_association, friend: friend, user: user)}
  let(:user) { create(:user, :volunteer, community: community) }

  before do
    login_as(regional_admin)
  end

  scenario 'approving a draft' do
    visit regional_admin_region_friend_path(region, friend)
    expect(ReviewMailer)
      .to receive_message_chain(:application_approved_email, :deliver_now)
        .and_return(double('ReviewMailer', deliver: true))

    click_link 'Approve Draft'

    expect(draft.reload.status).to eq 'approved'
    expect(application.reload.status).to eq 'approved'
    success_message = 'Draft approved.'
    expect(page).to have_content(success_message)
    expect(current_path).to eq regional_admin_region_friend_path(region, friend)
  end
end
