require 'rails_helper'

RSpec.describe 'Volunteer signing up for accompaniments', type: :feature, js: true do
  let!(:volunteer) { create(:user, :volunteer) }
  let!(:current_week_activity) { create(:activity, occur_at: Date.today.end_of_week - 3.days ) }
  let!(:next_week_activity) { create(:activity, occur_at: 1.week.from_now ) }
  before { login_as(volunteer) }

  describe 'viewing upcoming accompaniments' do
    before do
      visit root_path
      click_link 'Accompaniment Program'
    end

    it 'displays accompaniments in the current week' do
      expect(page).to have_content(current_week_activity.friend.first_name)
    end

    it 'displays accompaniments in the upcoming week' do
      expect(page).to have_content(next_week_activity.friend.first_name)
    end
  end

  describe 'signing up for an accompaniment' do
    before do
      visit activities_path
      within "#activity_#{current_week_activity.id}" do
        click_button 'Attend'
      end
      within "#activity_#{current_week_activity.id}_accompaniment_modal" do
        click_button 'Confirm'
      end
      wait_for_ajax
    end

    it 'creates an RSVP' do
      within '.alert' do
        expect(page).to have_content 'Your RSVP was successful.'
      end

      within "#activity_#{current_week_activity.id}" do
        expect(page).to have_content(volunteer.first_name)
      end

      within "#activity_#{current_week_activity.id}" do
        expect(page).to have_content('Edit RSVP')
      end
    end  
  end

  describe 'canceling an RSVP for an accompaniment' do
    let!(:accompaniment) { create(:accompaniment, activity: current_week_activity, user: volunteer) }
    before do
      visit activities_path
      within "#activity_#{current_week_activity.id}" do
        click_button 'Edit RSVP'
      end
      within "#activity_#{current_week_activity.id}_accompaniment_modal" do
        select 'No', from: 'Attending'
        click_button 'Confirm'
      end
      wait_for_ajax
    end

    it 'deletes the RSVP' do
      within '.alert' do
        expect(page).to have_content 'Your RSVP was deleted.'
      end
      within "#activity_#{current_week_activity.id}" do
        expect(page).to_not have_content(volunteer.first_name)
      end
      within "#activity_#{current_week_activity.id}" do
        expect(page).to have_content('Attend')
      end
    end
  end
end