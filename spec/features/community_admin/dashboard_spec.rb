require 'rails_helper'

RSpec.describe 'Admin creates a new event', type: :feature do

  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community, :primary }
  let!(:location) { create(:location, region: community.region) }
  let!(:friend) { create(:friend, community: community) }

  before do
    login_as(community_admin)
  end

  scenario 'correct landing page' do
    visit '/'
    expect(current_path).to eq community_admin_friends_path(community)
    expect(page).to have_content(friend.first_name)
    expect(page).to have_content(friend.last_name)
    expect(page).to have_content(friend.a_number)
  end
end
