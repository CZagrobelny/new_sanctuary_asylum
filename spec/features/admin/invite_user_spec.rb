require 'rails_helper'

RSpec.describe 'Admin invites a new user', type: :feature do

  let(:admin) { create(:user, :admin) }
  let(:email) { FFaker::Internet.email }

  before do 
    login_as(admin)
    visit new_user_invitation_path
    fill_in 'Email', with: email
  end

  describe 'inviting a new user' do

    it 'displays a message that the invitation was sent' do
      click_button 'Send an invitation'
      within '.alert' do
        expect(page).to have_content "An invitation email has been sent to #{email}."
      end
    end

    it 'sends the invitation' do
      expect{ click_button 'Send an invitation' }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end