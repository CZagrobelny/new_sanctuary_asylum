require 'rails_helper'

RSpec.describe 'Volunteer managing asylum application drafts for shared friends', type: :feature, js: true do
  let!(:volunteer) { create(:user, :volunteer) }
  let!(:shared_friend) { create(:friend) }
  let!(:not_shared_friend) { create(:friend) }
  let!(:user_friend_association) { create(:user_friend_association, friend: shared_friend, user: volunteer)}
  before { login_as(volunteer) }

  describe 'viewing shared friend records' do
    before do
      visit root_path
      click_link 'Asylum Clinic'
    end

    it 'displays friend records associated with the volunteer' do
      expect(page).to have_content(shared_friend.full_name)
    end

    it 'does not display friend records NOT associated with the volunteer' do
      expect(page).not_to have_content(not_shared_friend.full_name)
    end
  end

  describe 'adding a new asylum application draft' do
    before do
      visit friend_path(shared_friend)
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