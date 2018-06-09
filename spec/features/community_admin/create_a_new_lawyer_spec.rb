require 'rails_helper'

RSpec.describe 'Admin creates a new lawyer', type: :feature do
  let(:community_admin) { create(:user, :community_admin) }
  let(:community) { community_admin.community }
  let(:region) { community.region }

  before do
    login_as(community_admin)
  end

  scenario 'creating a new lawyer' do
    lawyer_count = region.lawyers.count
    visit new_community_admin_lawyer_path(community)

    fill_in 'First Name', with: FFaker::Name.first_name
    fill_in 'Last Name', with: FFaker::Name.last_name
    click_button 'Save'

    expect(region.lawyers.count).to eq (lawyer_count + 1)
    expect(current_path).to eq community_admin_lawyers_path(community)
  end

end