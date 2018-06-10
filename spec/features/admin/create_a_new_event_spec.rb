require 'rails_helper'

RSpec.describe 'Admin creates a new event', type: :feature do

  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community, :primary }
  let!(:location) { create(:location, region: community.region) }

  before do
    login_as(community_admin)
    visit new_community_admin_event_path(community)
  end

  describe 'creating an event' do
    scenario 'with valid inputs' do
      select 'Asylum Workshop', from: 'Category'
      fill_in 'Title', with: 'Cool New Event'
      select_date_and_time(Time.now.beginning_of_hour, from: 'event_date')
      select location.name, from: 'Location'
      click_button 'Save'

      within '.alert' do
        expect(page).to have_content 'Event saved.'
      end

      expect(current_path).to eq community_admin_events_path(community)
    end

    scenario 'with invalid inputs' do
      fill_in 'Title', with: 'Cool New Event'
      select_date_and_time(Time.now.beginning_of_hour, from: 'event_date')
      select location.name, from: 'Location'
      click_button 'Save'

      expect(page).to have_content "Category can't be blank"
    end
  end
end