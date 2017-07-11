require 'rails_helper'

RSpec.describe 'Friend edit', type: :feature, js: true do

  let!(:admin) { create(:user, :admin) }
  let!(:friend) { create(:friend) }

  before do
    3.times { create(:friend) }
    login_as(admin)
    visit edit_admin_friend_path(friend)
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
        click_button 'Add Family Member'
      end

      describe 'with valid information' do
        it 'displays the new family member' do
          family_member = Friend.last
          select 'Spouse', from: 'Relationship'
          select_from_chosen(family_member.name, from: {id: 'family_member_constructor_relation_id'})
          click_button 'Add'

          within '#family-list' do
            expect(page).to have_content(family_member.name)
          end
        end
      end

      describe 'with incomplete information' do
        it 'displays validation errors' do
          click_button 'Add'
          expect(page).to have_content("Relationship can't be blank")
        end
      end
    end
  end

  describe 'editing "Asylum" information' do

    describe 'adding a new asylum application draft' do
      before do
        click_link 'Asylum'
        click_link 'Add Asylum Application Draft'
      end

      describe 'with valid information' do
        it 'displays the new asylum application draft' do
          volunteer = User.last
          within '#add_asylum_application_draft_modal' do
            select_from_chosen(volunteer.name, from: {id: 'asylum_application_draft_user_ids'})
            fill_in 'Notes', with: 'This is the first draft.'
            click_button 'Save'
          end

          within '#asylum-application-draft-list' do
            expect(page).to have_content('This is the first draft.')
          end
        end
      end
    end
  end
end