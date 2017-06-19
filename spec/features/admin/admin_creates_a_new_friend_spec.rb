require 'rails_helper'

RSpec.describe 'Admin creates a new friend record', type: :feature do

  let(:admin) { create(:user, :admin) }

  before do 
    login_as(admin)
    visit new_admin_friend_path
  end

  describe 'when I visit /admin/friends/new' do
    it 'shows only the "Basic" tab' do
      expect(page).to have_content('Basic')
      expect(page).to_not have_content('Family')
      expect(page).to_not have_content('Activities')
      expect(page).to_not have_content('Asylum')
      expect(page).to_not have_content('Other Case Info')
    end

    it 'shows the basic friend form fields' do
      expect(page).to have_field('First Name')
      expect(page).to have_field('Middle Name')
      expect(page).to have_field('Last Name')
      expect(page).to have_field('A Number')
      expect(page).to have_field('Friend does not have an A Number')
      expect(page).to have_field('Phone')
      expect(page).to have_field('Email')
      expect(page).to have_field('Gender')
      expect(page).to have_field('Ethnicity')
      expect(page).to have_field('Languages')
      expect(page).to have_field('Country of Origin')
      expect(page).to have_field('Status')
      expect(page).to have_field('Notes')
    end
  end

  describe 'when I create a friend with valid inputs' do
    it 'saves the friend' do
    end

    it 'displays a success message' do
    end

    it 'redirects to the friend edit page' do
      expect(current_path).to eq edit_admin_friend_path(@friend)
    end
  end

  describe 'when I create a friend with invalid inputs' do
    it 'does not save the friend' do
    end
    
    it 'displays the validation errors' do
    end

    it 'keeps the user on the new page' do
      expect(current_path).to eq edit_admin_friend_path(@friend)
    end
  end    
end