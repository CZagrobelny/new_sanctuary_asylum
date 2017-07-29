require 'rails_helper'

RSpec.describe 'Admin creates a new lawyer', type: :feature do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
  end

  scenario 'creating a new judge' do
    lawyer_count = Lawyer.count
    visit new_admin_lawyer_path

    fill_in 'First Name', with: FFaker::Name.first_name
    fill_in 'Last Name', with: FFaker::Name.last_name
    click_button 'Save'

    expect(Lawyer.count).to eq (lawyer_count + 1)
    expect(current_path).to eq admin_lawyers_path
  end
  
end