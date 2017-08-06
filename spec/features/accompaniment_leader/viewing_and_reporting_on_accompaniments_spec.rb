require 'rails_helper'

RSpec.describe 'Accompaniment leader viewing and reporting on accompaniments', type: :feature do
  let!(:team_leader) { create(:user, :accompaniment_leader) }
  let!(:current_week_activity) { create(:activity, occur_at: Date.today.end_of_week - 3.days ) }
  let!(:next_week_activity) { create(:activity, occur_at: 1.week.from_now ) }
  let!(:activity_outside_date_range) { create(:activity, occur_at: 2.weeks.from_now) }
  let!(:accompaniment) { create(:accompaniment, user: team_leader, activity: current_week_activity) }
  before { login_as(team_leader) }

  describe 'viewing upcoming accompaniments' do
    before do
      visit root_path
      click_link 'Accompaniment Program'
    end

    it 'displays the accompaniment leader activities page' do
      expect(page).to have_current_path(accompaniment_leader_activities_path)
    end

    it 'displays full details of accompaniments in the current week' do
      expect(page).to have_content(current_week_activity.friend.first_name)
      expect(page).to have_content(current_week_activity.friend.phone)
    end

    it 'displays full details of accompaniments in the upcoming week' do
      expect(page).to have_content(next_week_activity.friend.first_name)
      expect(page).to have_content(current_week_activity.friend.phone)
    end

    it 'does not display accompaniments outside of the two week date range' do
      expect(page).to_not have_content(activity_outside_date_range.friend.first_name)
    end
  end

  describe 'attending an activity' do
    it 'lists me as "Team Leader" for the activity' do
      visit accompaniment_leader_activities_path
      within "#activity_#{current_week_activity.id}" do
        expect(page).to have_content("Team Leader: #{team_leader.name}")
      end
    end
  end

  describe 'creating an accompaniment report' do
    before do
      visit accompaniment_leader_activities_path
      within "#activity_#{current_week_activity.id}" do
        click_link 'Create Report'
      end
    end

    describe 'with valid info' do
      it 'displays a flash message that my RSVP was successful' do
        fill_in 'Notes', with: 'Test notes'
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'Your accompaniment report was created.'
        end
      end  
    end

    describe 'with invalid info' do
      it 'displays a flash message that my accompaniment report was NOT created' do
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'There was an error creating your accompaniement report.'
        end
      end 
    end
  end

  describe 'editing an accompaniment report' do
    let!(:accompaniment_report) { create(:accompaniment_report, activity: current_week_activity)}
    let!(:accompaniment_report_authorship) { create(:accompaniment_report_authorship, accompaniment_report: accompaniment_report, user: team_leader)}
    
    before do
      visit accompaniment_leader_activities_path
      within "#activity_#{current_week_activity.id}" do
        click_link 'Edit Report'
      end
    end

    describe 'with valid info' do
      it 'displays a flash message that my accompaniment report was updated' do
        fill_in 'Notes', with: 'Edited test notes'
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'Your accompaniment report was saved.'
        end
      end
    end

    describe 'with invalid info' do
      it 'displays a flash message that my accompaniment report was NOT updated' do
        fill_in 'Notes', with: ''
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'There was an error saving your accompaniement report.'
        end
      end
    end
  end
end