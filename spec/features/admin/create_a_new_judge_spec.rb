require 'rails_helper'

RSpec.describe 'Admin creates a new judge', type: :feature do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
  end

  scenario 'creating a new judge' do
    judge_count = Judge.count
    visit new_admin_judge_path

    fill_in 'First Name', with: FFaker::Name.first_name
    fill_in 'Last Name', with: FFaker::Name.last_name
    click_button 'Save'

    expect(Judge.count).to eq (judge_count + 1)
    expect(current_path).to eq admin_judges_path
  end
  
end
