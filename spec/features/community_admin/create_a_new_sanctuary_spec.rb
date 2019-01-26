require 'rails_helper'

RSpec.describe 'Admin creates a new sanctuary', type: :feature do
  let(:community_admin) { create(:user, :community_admin) }
  let(:community) { community_admin.community }

  before do
    login_as(community_admin)
  end

  scenario 'creating a new sanctuary' do
    sanctuary_count = community.sanctuaries.count
    visit new_community_admin_sanctuary_path(community)

    fill_in 'Name', with: Faker::Name.name
    fill_in 'Leader Name', with: Faker::Name.name
    click_button 'Save'

    expect(community.sanctuaries.count).to eq (sanctuary_count + 1)
    expect(current_path).to eq community_admin_sanctuaries_path(community)
  end

end