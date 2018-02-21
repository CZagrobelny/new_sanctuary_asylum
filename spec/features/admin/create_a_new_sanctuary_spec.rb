require 'rails_helper'

RSpec.describe 'Admin creates a new sanctuary', type: :feature do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
  end

  scenario 'creating a new sanctuary' do
    location_count = Sanctuary.count
    visit new_admin_sanctuary_path

    fill_in 'Name', with: FFaker::Name.name
    fill_in 'Leader Name', with: FFaker::Name.name
    click_button 'Save'

    expect(Sanctuary.count).to eq (location_count + 1)
    expect(current_path).to eq admin_sanctuaries_path
  end

end