require 'rails_helper'

RSpec.describe 'Admin creates a new location', type: :feature do
  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community, :primary }
  let(:region) { community.region }

  before do
    login_as(community_admin)
  end

  scenario 'creating a new location' do
    location_count = region.locations.count
    visit new_community_admin_location_path(community)

    fill_in 'Name', with: FFaker::Name.name
    click_button 'Save'

    expect(region.locations.count).to eq (location_count + 1)
    expect(current_path).to eq community_admin_locations_path(community)
  end

end