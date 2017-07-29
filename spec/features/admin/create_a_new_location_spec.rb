require 'rails_helper'

RSpec.describe 'Admin creates a new location', type: :feature do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
  end

  scenario 'creating a new location' do
    location_count = Location.count
    visit new_admin_location_path

    fill_in 'Name', with: FFaker::Name.name
    click_button 'Save'

    expect(Location.count).to eq (location_count + 1)
    expect(current_path).to eq admin_locations_path
  end
  
end