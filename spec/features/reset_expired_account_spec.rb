require 'rails_helper'

RSpec.describe 'Resetting expired accounts', type: :feature do
  let(:password) { '1OKlongpassphrase' }
  let(:new_password) { '1OKreplacement' }
  let(:user) do
    create(:user, password: password).tap do |user|
      user.need_change_password!
    end
  end

  before do
    # Necessary preliminary step
    visit root_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_on 'Log in'

    expect(page).to have_content('Your password is expired')
  end

  scenario 'Account should allow resetting password from link' do
    visit root_path

    expect(current_path).to eq(user_password_expired_path)
    expect(page).to have_content('Your password is expired')

    fill_in 'New password', with: new_password
    fill_in 'Confirm new password', with: new_password
    click_on 'Change my password'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Your new password is saved')
  end
end
