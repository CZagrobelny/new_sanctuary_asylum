require 'rails_helper'

RSpec.describe 'Volunteer signing up for accompaniments', type: :feature, js: true do
  let(:community) { create :community, :primary }
  let(:region) { community.region }
  let(:volunteer) { create(:user, :volunteer, community: community) }
  let!(:activity) { create(:activity, occur_at: 1.week.from_now, region: region, confirmed: true ) }
  let(:accompaniment_listing) { "#{activity.event.humanize} for #{activity.friend.first_name} at #{activity.location.name}" }
  before { login_as(volunteer) }

  describe 'viewing upcoming accompaniments' do
    # TO DO: this spec will fail intermittently if it needs to advance to the next month in order to view the accompaniment :/
    before do
      visit community_activities_path(community)
    end

    it 'displays full details of upcoming accompaniments' do
      expect(page).to have_content(accompaniment_listing)
    end
  end

  describe 'signing up for an accompaniment' do
    before do
      visit community_activities_path(community)
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
      visit community_activities_path(community)
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