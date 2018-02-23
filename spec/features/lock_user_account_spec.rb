require 'rails_helper'

RSpec.describe 'User account is locked', type: :feature do

  let(:user) { create(:user) }

  scenario 'User has one attempt left before their account is locked' do
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
    expect(current_path).to eq root_path
    expect(page).to have_content 'You have one more attempt before your account is locked.'
  end

  scenario 'User attempts to log in after 10 failed attempts' do
    visit root_path

    10.times do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_on 'Log in'
    end

    user.reload
    expect(user.failed_attempts).to eq 10

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_on 'Log in'
    expect(current_path).to eq root_path
    expect(page).to have_content 'Your account is locked.'
  end
end