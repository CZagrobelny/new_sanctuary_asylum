require 'rails_helper'

RSpec.describe 'Admin creates a new event', type: :feature do

  let(:admin) { create(:user, :admin) }
  let!(:location) { create(:location) }

  before do 
    login_as(admin)
    visit new_admin_event_path
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

      expect(current_path).to eq admin_events_path
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