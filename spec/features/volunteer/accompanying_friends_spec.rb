require 'rails_helper'
require 'support/simple_calendar_date_chooser'
include SimpleCalendarDateChooser

RSpec.describe 'Volunteer signing up for accompaniments', type: :feature, js: true do
  let(:community) { create :community, :primary }
  let(:region) { community.region }
  let(:volunteer) { create(:user, :volunteer, community: community) }
  let!(:activity) { create(:activity, occur_at: 1.week.from_now, region: region, confirmed: true ) }
  let(:accompaniment_listing) { "#{activity.event.humanize} for #{activity.friend.first_name} at #{activity.location.name}" }

  before do
    login_as(volunteer)
    visit community_activities_path(community)
    change_month(activity.occur_at)
  end

  describe 'viewing upcoming accompaniments' do
    it 'displays full details of upcoming accompaniments' do
      expect(page).to have_content(accompaniment_listing)
    end
  end

  describe 'signing up for an accompaniment' do
    before do
      click_link accompaniment_listing
      within "#modal_activity_#{activity.id}" do
        click_button 'Save'
      end
    end

    it 'creates an RSVP' do
      within '.alert' do
        expect(page).to have_content 'Your RSVP was successful.'
      end
    end
  end

  describe 'canceling an RSVP for an accompaniment' do
    let!(:accompaniment) { create(:accompaniment, activity: activity, user: volunteer) }
    before do
      click_link accompaniment_listing
      within "#modal_activity_#{activity.id}" do
        select 'No', from: 'Attending'
        click_button 'Save'
      end
    end

    it 'deletes the RSVP' do
      within '.alert' do
        expect(page).to have_content 'Your RSVP was deleted.'
      end
    end
  end
end