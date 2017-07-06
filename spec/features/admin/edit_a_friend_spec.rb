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
          select_from_chosen(family_member.full_name, from: {id: 'family_member_constructor_relation_id'})
          click_button 'Add'

          within '#family-list' do
            expect(page).to have_content(family_member.full_name)
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
end