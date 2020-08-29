require 'rails_helper'
require 'support/simple_calendar_date_chooser'
include SimpleCalendarDateChooser

RSpec.describe 'Accompaniment leader viewing and reporting on accompaniments', type: :feature do
  let(:community) { create :community, :primary }
  let(:region) { community.region }
  let(:friend) { create :friend, community: community, region: region }
  let(:team_leader) { create(:user, :accompaniment_leader, community: community) }
  let!(:activity) { create(:activity, friend: friend, occur_at: 1.week.from_now, region: region, location: create(:location, region: region), activity_type: activity_type, confirmed: true) }
  let!(:activity_type) { create :activity_type }
  let!(:accompaniment) { create(:accompaniment, user: team_leader, activity: activity) }
  let(:accompaniment_listing) { "#{activity.activity_type.name.titlecase} for #{activity.friend.first_name} at #{activity.location.name}" }
  before do
    login_as(team_leader)
  end

  describe 'viewing upcoming accompaniments' do
    before do
      visit community_accompaniment_leader_activities_path(community)
      change_month(activity.occur_at)
    end

    it 'displays full details of upcoming accompaniments' do
      activity.activity_type = activity_type
      expect(page).to have_content(accompaniment_listing)
    end
  end

  describe 'creating an accompaniment report' do
    before do
      visit new_community_accompaniment_leader_activity_accompaniment_report_path(community, activity)
    end

    context 'with valid info' do
      it 'displays a flash message that my accompaniment leader notes were addded' do
        fill_in 'Outcome of hearing', with: 'outcome'
        fill_in 'Notes', with: 'Test notes'
        fill_in 'Judge-imposed asylum application deadline', with: '5/31/2020'
        check 'Has a Lawyer'
        fill_in 'Lawyer Name', with: 'Susan Example'
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'Your accompaniment leader notes were added.'
        end

        updated_friend = activity.friend.reload
        expect(updated_friend.judge_imposed_i589_deadline.to_date).to eq Date.new(2020, 5, 31)
        expect(updated_friend.has_a_lawyer?).to be_truthy
        expect(updated_friend.lawyer_name).to eq 'Susan Example'
      end
    end

    context 'with invalid info' do
      it 'displays a flash message that my accompaniment report was NOT created' do
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'There was an error saving your accompaniment leader notes.'
        end
      end
    end
  end

  describe 'editing an accompaniment report' do
    let!(:accompaniment_report) { create(:accompaniment_report, activity: activity, user: team_leader, friend: friend)}

    before do
      report = team_leader.accompaniment_report_for(activity)
      visit edit_community_accompaniment_leader_activity_accompaniment_report_path(community, activity, report)
    end

    context 'with valid info' do
      it 'displays a flash message that my accompaniment report was updated' do
        fill_in 'Notes', with: 'Edited test notes'
        click_button 'Save'
        within '.alert' do
          expect(page).to have_content 'Your accompaniment leader notes were saved.'
        end
      end
    end

    context 'with invalid info' do
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
