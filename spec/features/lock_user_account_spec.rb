require 'rails_helper'

RSpec.describe 'User account gets locked', type: :feature do

  let(:user) { create(:user) }

  scenario 'logging in with invalid credentials after eight attempts' do
    visit root_path

    8.times do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_on 'Log in'
    end

    user.reload
    expect(user.failed_attempts).to eq 8

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_on 'Log in'
    expect(current_path).to eq root_path
    expect(page).to have_content 'You have 1 more attempt before your account is locked.'
  end

  scenario 'logging in with invalid credentials after nine attempts' do
    visit root_path

    9.times do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_on 'Log in'
    end

    user.reload
    expect(user.failed_attempts).to eq 9

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_on 'Log in'
    expect(current_path).to eq new_user_unlock_path
    expect(page).to have_content 'Your account is locked.'
  end
end