require 'rails_helper'

RSpec.describe 'Regional Admin manages communities', type: :feature do

  let(:regional_admin) { create :user, :regional_admin, community: community }
  let(:community) { create :community }
  let(:region) { community.region }
  let(:other_region) { create :region }

  before do
    login_as(regional_admin)
  end

  scenario 'viewing communities in a region' do
    visit regional_admin_region_communities_path(region, community.id)
    expect(page).to have_content(community.name)
  end

  describe 'creating a community' do
    scenario 'with valid inputs' do
      visit new_regional_admin_region_community_path(region)

      fill_in 'Name', with: 'A new community'
      fill_in 'Slug', with: 'new-community'
      click_button 'Save'
      expect(page).to have_link('A new community')
    end

    scenario 'with invalid inputs' do
      visit new_regional_admin_region_community_path(region)
      click_button 'Save'
      expect(page).to have_content 'Slug must be all lowercase letters with no spaces. Dashes may be used to separate words, like "a-slug-with-dashes"'
    end
  end

  scenario 'editing a community' do
    visit edit_regional_admin_region_community_path(region, community.id)
    fill_in 'Name', with: 'An updated name'
    click_button 'Save'
    expect(page).to have_link('An updated name')
  end

  scenario 'navigating to a community' do
    visit regional_admin_region_communities_path(region, community)
    within '.regional_admin' do
      click_link community.name
      expect(current_path).to eq community_admin_path(community)
    end
  end
end