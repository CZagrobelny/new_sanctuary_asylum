require 'rails_helper'

RSpec.describe 'Volunteer signing up for accompaniments', type: :feature, js: true do
  let(:community) { create :community }
  let(:region) { community.region }
  let(:volunteer) { create(:user, :volunteer, community: community) }
  let!(:activity) { create(:activity, occur_at: 1.week.from_now, region: region, confirmed: true ) }
  before { login_as(volunteer) }

  describe 'viewing upcoming accompaniments' do
    before do
      visit community_activities_path(community)
    end

    it 'displays full details of upcoming accompaniments' do
      expect(page).to have_content(activity.friend.first_name)
      expect(page).to have_content(activity.friend.phone)
    end
  end

  describe 'signing up for an accompaniment' do
    before do
      visit community_activities_path(community)
      within "#activity_#{activity.id}" do
        click_button 'Attend'
      end
      within "#activity_#{activity.id}_accompaniment_modal" do
        click_button 'Confirm'
      end
    end

    it 'creates an RSVP' do
      within '.alert' do
        expect(page).to have_content 'Your RSVP was successful.'
      end

      within "#activity_#{activity.id}" do
        expect(page).to have_content(volunteer.first_name)
      end

      within "#activity_#{activity.id}" do
        expect(page).to have_content('Edit RSVP')
      end
    end
  end

  describe 'canceling an RSVP for an accompaniment' do
    let!(:accompaniment) { create(:accompaniment, activity: activity, user: volunteer) }
    before do
      visit community_activities_path(community)
      within "#activity_#{activity.id}" do
        click_button 'Edit RSVP'
      end
      within "#activity_#{activity.id}_accompaniment_modal" do
        select 'No', from: 'Attending'
        click_button 'Confirm'
      end
    end

    it 'deletes the RSVP' do
      within '.alert' do
        expect(page).to have_content 'Your RSVP was deleted.'
      end
      within "#activity_#{activity.id}" do
        expect(page).to_not have_content(volunteer.first_name)
      end
      within "#activity_#{activity.id}" do
        expect(page).to have_content('Attend')
      end
    end
  end
end