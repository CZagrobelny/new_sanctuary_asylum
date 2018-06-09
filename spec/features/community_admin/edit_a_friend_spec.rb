require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe 'Friend edit', type: :feature, js: true do

  let(:community_admin) { create(:user, :community_admin, community: community) }
  let(:community) { create :community }
  let!(:friend) { create(:friend, community: community) }
  let!(:location) { create(:location, region: community.region) }

  before do
    3.times { create(:friend, community: community) }
    login_as(community_admin)
    visit edit_community_admin_friend_path(community, friend)
  end

  describe 'editing "Basic" information' do
    it 'displays the "Basic" tab' do
      within '.tab-content' do
        expect(page).to have_content 'Basic'
      end
    end
  end

  describe 'editing "Family" information' do
    describe 'adding a new family relationship' do
      before do
        click_link 'Family'
      end

      describe 'with valid information' do
        it 'displays the new family member' do
          expect(page).to have_link 'Add Family Member'
          click_link 'Add Family Member'
          sleep 1
          family_member = Friend.last
          select 'Spouse', from: 'Relationship'
          expect(page).to have_select('Relationship', selected: 'Spouse')
          select_from_chosen(family_member.name, from: {id: 'family_member_constructor_relation_id'})
          click_button 'Add'
          wait_for_ajax

          within '#family-list' do
            expect(page).to have_content(family_member.name)
          end
        end
      end

      describe 'with incomplete information' do
        it 'displays validation errors' do
          expect(page).to have_link 'Add Family Member'
          click_link 'Add Family Member'
          sleep 1
          click_button 'Add'
          wait_for_ajax
          expect(page).to have_content("Relationship can't be blank")
        end
      end
    end
  end

  describe 'editing "Activity" information' do

    describe 'adding a new activity' do
      before do
        within '.nav-tabs' do
          click_link 'Activities'
        end
      end

      describe 'with valid information' do
        it 'displays the new activity' do
          expect(page).to have_link 'Add Activity'
          click_link 'Add Activity'
          sleep 1
          select 'Individual Hearing', from: 'Type'
          expect(page).to have_select('Type', selected: 'Individual Hearing')
          select location.name, from: 'Location'
          select_date_and_time(Time.now.beginning_of_hour, from: 'activity_occur_at')
          within '#new_activity' do
            click_button 'Save'
          end
          wait_for_ajax
          within '#activity-list' do
            expect(page).to have_content('Individual hearing')
            expect(page).to have_content(location.name)
          end
        end
      end

      describe 'with incomplete information' do
        it 'displays validation errors' do
          expect(page).to have_link 'Add Activity'
          click_link 'Add Activity'
          sleep 1
          within '#new_activity' do
            click_button 'Save'
          end
          wait_for_ajax
          expect(page).to have_content("Event can't be blank")
        end
      end
    end
  end

  describe 'editing "Clinic" information' do
    it 'displays the "Clinic tab"' do
      within '.nav-tabs' do
        click_link 'Clinic'
      end
      within '.tab-content' do
        expect(page).to have_content 'Asylum'
      end
    end
  end

  describe 'editing "Detention" information' do
    describe 'adding a new Detention' do
      before do
        within '.nav-tabs' do
          click_link 'Detention'
        end
      end

      describe 'with valid information' do

      end

      describe 'with incomplete information' do

      end
    end
  end

  describe 'editing "Other Case Info"' do
    it 'displays the "Other Case Info" tab' do
      within '.nav-tabs' do
        click_link 'Other Case Info'
      end
      within '.tab-content' do
        expect(page).to have_content 'Lawyer'
      end
    end
  end

  describe 'editing "Documents"' do
    before {click_link 'Documents'}
    # add the scenario wherein there is at least one file
    it 'displays the "Documents" tab' do
      within '.tab-content' do
        expect(page).to have_content 'There are no files associated with this user.'
      end
    end

    it 'redirects to application drafts page' do
      click_button 'Manage Documents'
      expect(current_path).to eq community_friend_application_drafts_path(community_slug: community.slug, friend_id: friend.id)
    end
  end
end
