require 'rails_helper'

RSpec.describe 'User account is locked', type: :feature do

  let(:user) { create(:user) }

  scenario 'Lockable account after 10 failed attempts' do
    visit new_user_session_path

    20.times do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_on 'Log in'
      user.reload
      puts user.failed_attempts
    end

    assert_equal 10, user.failed_attempts
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_on 'Log in'
    expect(page).to have_content 'Your account is locked.'
  end
end