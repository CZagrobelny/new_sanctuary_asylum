require 'rails_helper'

RSpec.describe 'Admin invites a new user', type: :feature do

  let(:admin) { create(:user, :community_admin, community: community) }
  let(:regional_admin) { create(:user, :regional_admin, community: community) }
  let(:community) { create(:community) }
  let(:email) { Faker::Internet.email }

  describe 'admin inviting a new user' do
    before do
      login_as(admin)
      visit new_user_community_invitation_path(community)
      fill_in 'Email', with: email
    end

    it 'displays a message that the invitation was sent' do
      click_button 'Send an invitation'
      within '.alert' do
        expect(page).to have_content "An invitation email has been sent to #{email}."
      end
    end

    it 'does not display the remote clinic lawyer checkbox' do
      expect(page).to_not have_content('Remote Clinic Lawyer')
    end

    it 'sends the invitation' do
      expect{ click_button 'Send an invitation' }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
  describe 'remote admin inviting a new user' do
    before do
      login_as(regional_admin)
      visit new_user_community_invitation_path(community)
      fill_in 'Email', with: email
    end
    it 'does display the remote clinic lawyer checkbox' do
      expect(page).to have_content('Remote Clinic Lawyer')
    end
  end
  describe 'user accepting an invitation' do
    before do
      login_as(admin)
      visit new_user_community_invitation_path(community)
      fill_in 'Email', with: email
      click_button 'Send an invitation'
      confirmation_link = URI.extract(ActionMailer::Base.deliveries.last.text_part.body.to_s)[1]
      logout(admin)
      visit confirmation_link
    end

    describe 'with valid information' do
      it 'signs in the user' do
        fill_in 'First Name', with: Faker::Name.first_name
        fill_in 'Last Name', with: Faker::Name.last_name
        fill_in 'Phone', with: '876 765 4455'
        fill_in 'Password', with: 'Password1234'
        fill_in 'Password Confirmation', with: 'Password1234'
        check 'user_pledge_signed'
        click_button 'Save'

        expect(page).to have_content('Your password was set successfully. You are now signed in.')
        expect(current_path).to eq(community_dashboard_path(community))
      end
    end

    describe 'with invalid information' do
      it 'displays validation errors' do
        click_button 'Save'
        expect(page).to have_content("First name can't be blank")
      end

      it 'does not sign in the user' do
        click_button 'Save'
        expect(page).not_to have_content('Your password was set successfully. You are now signed in.')
      end
    end
  end
end