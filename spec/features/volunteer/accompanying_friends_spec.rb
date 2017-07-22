require 'rails_helper'

RSpec.describe 'Volunteer signing up for accompaniments', type: :feature do
  let!(:volunteer) { create(:user, :volunteer) }
  let!(:current_week_activity) { create(:activity, occur_at: Time.now ) }
  let!(:next_week_activity) { create(:activity, occur_at: 1.week.from_now ) }
  let!(:activity_outside_date_range) { create(:activity, occur_at: 2.weeks.from_now) }
  before { login_as(volunteer) }

  describe 'viewing upcoming accompaniments' do
    before do
      visit root_path
      click_link 'Accompaniement Program'
    end

    it 'displays accompaniments in the current week' do
      expect(page).to have_content(current_week_activity.friend.first_name)
    end

    it 'displays accompaniements in the upcoming week' do
      expect(page).to have_content(next_week_activity.friend.first_name)
    end

    it 'does not display accompaniements outside of the two week date range' do
      expect(page).to_not have_content(activity_outside_date_range.friend.first_name)
    end
  end

  describe 'signing up for an accompaniment' do
    before do
      visit activities_path
      within "#activity_#{current_week_activity.id}" do
        click_button 'Attend'
      end
      within "#activity_#{current_week_activity.id}_accompaniement_modal" do
        click_button 'Confirm'
      end
    end

    it 'displays a flash message that my RSVP was successful' do
      within '.alert' do
        expect(page).to have_content 'Your RSVP was successful.'
      end
    end  
    it 'lists my first name as a "Volunteer" for the activity' do
      within "#activity_#{current_week_activity.id}" do
        expect(page).to have_content(volunteer.first_name)
      end
    end
    it 'displays a button to "Edit RSVP" for the activity' do
      within "#activity_#{current_week_activity.id}" do
        expect(page).to have_content('Edit RSVP')
      end
    end
  end

  describe 'canceling an RSVP for an accompaniment' do
    let!(:accompaniement) { create(:accompaniement, activity: current_week_activity, user: volunteer) }
    before do
      visit activities_path
      within "#activity_#{current_week_activity.id}" do
        click_button 'Edit RSVP'
      end
      within "#activity_#{current_week_activity.id}_accompaniement_modal" do
        select 'No', from: 'Attending'
        click_button 'Confirm'
      end
    end

    it 'displays a flash message that my RSVP was deleted' do
      within '.alert' do
        expect(page).to have_content 'Your RSVP was deleted.'
      end
    end 
    it 'does not list my first name as a "Volunteer" for the activity' do
      within "#activity_#{current_week_activity.id}" do
        expect(page).to_not have_content(volunteer.first_name)
      end
    end
    it 'displays a button to "Attend" for the activity' do
      within "#activity_#{current_week_activity.id}" do
        expect(page).to have_content('Attend')
      end
    end
  end
end