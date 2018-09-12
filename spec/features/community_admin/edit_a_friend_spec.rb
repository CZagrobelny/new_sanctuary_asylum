require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe 'Friend edit', type: :feature, js: true do
  describe 'non-primary community' do
    let(:community) { create :community }
    let(:community_admin) { create(:user, :community_admin, community: community) }
    let(:friend) { create(:friend, community: community) }
    let!(:location) { create(:location, region: community.region) }
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
            select_from_chosen(family_member.name, from: { id: 'family_relationship_relation_id' })
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
            expect(page).to have_content("Relationship type can't be blank")
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

        it 'displays the new detention' do
          expect(page).to have_link 'Add Detention'
          click_link 'Add Detention'
          sleep 1
          select 'Immigration Court', from: 'Case Status'
          within '#new_detention' do
            click_button 'Save'
          end
          within '#detention-list' do
            expect(page).to have_content('Immigration Court')
          end
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
      before  { click_link 'Documents' }

      it 'displays the application category' do
        expect(page).to have_content application.category.titlecase
      end

      it 'displays the draft name' do
        expect(page).to have_link 'nsc_logo.png'
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
