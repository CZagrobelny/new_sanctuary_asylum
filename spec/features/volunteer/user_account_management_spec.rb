require 'rails_helper'

RSpec.describe 'User account management', type: :feature do

  let!(:volunteer) { create(:user, :volunteer) }

  before { login_as(volunteer) }

  describe 'a volunteer editing their user account' do
    it 'allows editing' do
      visit edit_user_path(volunteer)
      
      expect(page).to have_content('My Information')

      fill_in 'Last Name', with: 'New Name'
      click_button 'Save'

      expect(current_path).to eq dashboard_path

      within(".navbar") do
        expect(page).to have_content 'New Name'
      end
    end

    it 'does not allow editing other user accounts' do
      @other_user = create(:user, :volunteer)
      expect { visit edit_user_path(@other_user) }.to raise_error
    end
  end    
end