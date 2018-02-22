require 'rails_helper'

RSpec.describe 'User account is locked', type: :feature do

  let(:user) { create(:user) }

  scenario 'User attempts to log in after 10 failed attempts' do
    visit new_user_session_path

    10.times do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_on 'Log in'
      user.reload
    end

    expect(user.failed_attempts).to eq 10

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_on 'Log in'
    expect(current_path).to eq new_user_unlock_path
    expect(page).to have_content 'Your account is locked.'
  end
end