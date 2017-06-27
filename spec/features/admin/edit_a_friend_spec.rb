require 'rails_helper'

RSpec.describe 'Friend edit', type: :feature do

  let!(:admin) { create(:user, :admin) }
  let!(:friend) { create(:friend) }

  before { login_as(admin) }

  
  describe 'friend editing' do

    it 'displays all tabs' do
    end

    it 'allows editing' do
      fill_in 'Last Name', with: 'New Name'
      click_button 'Save'

      expect(find_field('Last Name').value).to eq 'New Name'
    end

    describe 'adding a family member' do
      
    end
  end    
end