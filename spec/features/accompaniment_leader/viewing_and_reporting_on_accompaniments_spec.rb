require 'rails_helper'
require 'support/simple_calendar_date_chooser'
include SimpleCalendarDateChooser

RSpec.describe 'Accompaniment leader viewing and reporting on accompaniments', type: :feature do
  let(:community) { create :community, :primary }
  let(:region) { community.region }
  let(:team_leader) { create(:user, :accompaniment_leader, community: community) }
  let!(:activity) { create(:activity, occur_at: 1.week.from_now, region: region, confirmed: true) }
  let!(:accompaniment) { create(:accompaniment, user: team_leader, activity: activity) }
  let(:accompaniment_listing) { "#{activity.event.humanize} for #{activity.friend.first_name} at #{activity.location.name}" }
  before do
    login_as(team_leader)
  end

  describe 'viewing upcoming accompaniments' do
    before do
      visit community_accompaniment_leader_activities_path(community)
      change_month(activity.occur_at)
    end

    it 'displays full details of upcoming accompaniments' do
      expect(page).to have_content(accompaniment_listing)
    end

    describe 'when the team leader is attending an activity' do
      it 'lists me as "Team Leader" for the activity' do
        click_link accompaniment_listing
        within "#modal_activity_#{activity.id}" do
          expect(page).to have_content("Accompaniment Leaders: #{team_leader.name}")
        end
      end
    end
  end

  describe 'creating an accompaniment report' do
    before do
      visit new_community_accompaniment_leader_activity_accompaniment_report_path(community, activity)
      change_month(activity.occur_at)
    end

    describe 'with valid info' do
      it 'displays a flash message that my accompaniment leader notes were addded' do
        fill_in 'Notes', with: 'Test notes'
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'Your accompaniment leader notes were added.'
        end
      end
    end

    describe 'with invalid info' do
      it 'displays a flash message that my accompaniment report was NOT created' do
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'There was an error saving your accompaniment leader notes.'
        end
      end
    end
  end

  describe 'editing an accompaniment report' do
    let!(:accompaniment_report) { create(:accompaniment_report, activity: activity, user: team_leader)}

    before do
      report = team_leader.accompaniment_report_for(activity)
      visit edit_community_accompaniment_leader_activity_accompaniment_report_path(community, activity, report)
      change_month(activity.occur_at)
    end

    describe 'with valid info' do
      it 'displays a flash message that my accompaniment report was updated' do
        fill_in 'Notes', with: 'Edited test notes'
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'Your accompaniment leader notes were saved.'
        end
      end
    end

    describe 'with invalid info' do
      it 'displays a flash message that my accompaniment report was NOT updated' do
        fill_in 'Notes', with: ''
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'There was an error saving your accompaniment leader notes.'
        end
      end
    end
  end
end