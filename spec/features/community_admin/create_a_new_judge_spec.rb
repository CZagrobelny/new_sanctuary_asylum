require 'rails_helper'

RSpec.describe 'Admin creates a new judge', type: :feature do
  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community, :primary }
  let(:region) { community.region }

  before do
    login_as(community_admin)
  end

  scenario 'creating a new judge' do
    visit new_community_admin_judge_path(community)

    fill_in 'First Name', with: Faker::Name.first_name
    fill_in 'Last Name', with: Faker::Name.last_name

    expect { click_button 'Save' }.to change { region.judges.count }.from(0).to(1)
    expect(current_path).to eq community_admin_judges_path(community)
  end

  scenario 'hiding a judge' do
    create(:judge, region: region)

    visit community_admin_judges_path(community)

    expect { click_on 'Hide' }.to change { region.judges.active.count }.from(1).to(0)
    expect { click_on 'Show' }.to change { region.judges.active.count }.from(0).to(1)
  end
end
