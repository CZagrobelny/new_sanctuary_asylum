require 'rails_helper'

RSpec.describe 'Admin creates a new judge', type: :feature do
  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community, :primary }
  let(:region) { community.region }

  before do
    login_as(community_admin)
  end

  scenario 'creating a new judge' do
    judge_count = region.judges.count
    visit new_community_admin_judge_path(community)

    fill_in 'First Name', with: FFaker::Name.first_name
    fill_in 'Last Name', with: FFaker::Name.last_name
    click_button 'Save'

    expect(region.judges.count).to eq (judge_count + 1)
    expect(current_path).to eq community_admin_judges_path(community)
  end

end
