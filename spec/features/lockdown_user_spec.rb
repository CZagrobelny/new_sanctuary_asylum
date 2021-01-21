require 'rails_helper'

RSpec.describe 'User locks down their account', type: :feature do

  let(:user) { create(:user) }

  context 'when there is a user matching the email' do
    scenario 'successfully locks down user account' do
      visit lockdown_path

      fill_in 'Email', with: user.email
      click_button 'Lockdown'
      expect(page).to have_content 'Lockdown succeeded.'
    end
  end

  context 'when there is no user matching the email' do
    scenario 'fails to lock down user account' do
      visit lockdown_path

      email = user.email + 'a'
      fill_in 'Email', with: email
      click_button 'Lockdown'
      expect(page).to have_content "Lockdown for #{email} failed."
    end
  end
end
