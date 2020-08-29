require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe 'Friend edit', type: :feature, js: true do
  describe 'non-primary community' do
    let(:community) { create :community }
    let(:community_admin) { create(:user, :community_admin, community: community) }
    let(:friend) { create(:friend, community: community) }
    let!(:location) { create(:location, region: community.region) }
    let!(:activity_type) { create(:activity_type) }
    let!(:application) { create(:application, friend: friend) }
    let!(:draft) { create(:draft, friend: friend, application: application) }

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
      describe 'adding a new family relationship with valid information' do
        it 'displays the new family member' do
          family_member = Friend.last
          expect(page).to have_link 'Add Family Member'
          click_link 'Add Family Member'
          within '#add_family_relationship_modal' do
            expect(page).to have_content('Add a Family Member')
            expect(page).to have_select('Relationship type', selected: '')
            select 'Spouse', from: 'Relationship type'
            expect(page).to have_select('Relationship type', selected: 'Spouse')
            select2(family_member.name, from: 'Family Member', search: true)
            click_button 'Add'
          end
          within '#family-list' do
            expect(page).to have_content("Spouse: #{family_member.name}")
          end
        end

        describe 'adding a new family relationship with incomplete information' do
          it 'displays validation errors' do
            expect(page).to have_link 'Add Family Member'
            click_link 'Add Family Member'
            within '#add_family_relationship_modal' do
              expect(page).to have_select('Relationship type', selected: '')
              click_button 'Add'
              expect(page).to have_content("Relationship type can't be blank")
            end
          end
        end
      end
    end

    describe 'editing "Note" information' do
      describe 'adding a new Note' do
        before do
          within '.nav-tabs' do
            click_link 'Notes'
          end
        end

        it 'displays the new note' do
          expect(page).to have_link 'Add Note'
          click_link 'Add Note'
          sleep 1
          fill_in 'Note', with: 'a test note'
          within '#friend-note-form' do
            click_button 'Save'
          end
          within '#friend-notes-list' do
            expect(page).to have_content('a test note')
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
            expect(page).to have_link 'Add Activity/Accompaniment'
            click_link 'Add Activity/Accompaniment'
            sleep 1
            select activity_type.display_name_with_accompaniment_eligibility, from: 'Type'
            expect(page).to have_select('Type', selected: activity_type.display_name_with_accompaniment_eligibility)
            select location.name, from: 'activity_location_id'
            select_date_and_time(Time.now.beginning_of_hour, from: 'activity_occur_at')
            within '#new_activity' do
              click_button 'Save'
            end
            wait_for_ajax
            within '#activity-list' do
              expect(page).to have_content(activity_type.display_name)
              expect(page).to have_content(location.name)
            end
          end
        end

        describe 'with incomplete information' do
          it 'displays validation errors' do
            expect(page).to have_link 'Add Activity/Accompaniment'
            click_link 'Add Activity/Accompaniment'
            sleep 1
            within '#new_activity' do
              click_button 'Save'
            end
            wait_for_ajax
            expect(page).to have_content("Activity type can't be blank")
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
          expect(page).to have_content 'Clinic Plan'
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

        it 'displays the new detention' do
          expect(page).to have_link 'Add Detention'
          click_link 'Add Detention'
          sleep 1
          select 'Immigration Court', from: 'Case Status'
          select location.name, from: 'Location'
          within '#new_detention' do
            click_button 'Save'
          end
          within '#detention-list' do
            expect(page).to have_content('Immigration Court')
          end
        end
      end
    end

    describe 'editing "Documents"' do
      before  { click_link 'Documents' }

      it 'displays the application category' do
        expect(page).to have_content application.category.titlecase
      end

      it 'displays the draft name' do
        expect(page).to have_content 'nsc_logo.png'
      end

      it 'displays a "Submit for Review" link' do
        expect(page).to have_link('Submit for Review')
      end

      it 'redirects to application drafts page to "Manage Documents"' do
        click_button 'Manage Documents'
        expect(current_path).to eq community_friend_drafts_path(community_slug: community.slug, friend_id: friend.id)
      end
    end
  end

  describe 'primary community' do
    let(:community) { create :community, :primary }
    let(:community_admin) { create(:user, :community_admin, community: community) }
    let(:friend) { create(:friend, community: community) }
    let(:location) { create(:location, region: community.region) }
    let!(:application) { create(:application, friend: friend) }
    let!(:draft) { create(:draft, friend: friend, application: application) }

    before do
      3.times { create(:friend, community: community) }
      login_as(community_admin)
      visit edit_community_admin_friend_path(community, friend)
    end

    describe 'editing "Documents"' do
      before do
        click_link 'Documents'
      end

      it 'does NOT display a "Submit for Review" link' do
        expect(page).to_not have_link('Submit for Review')
      end
    end
  end
end
