require 'rails_helper'

RSpec.describe 'Volunteer signing up for accompaniments', type: :feature do
  let!(:volunteer) { create(:user, :volunteer)

  describe 'viewing upcoming accompaniments' do
    before do
      visit root_path
      click_link 'Accompaniement Program'
    end

    it 'displays the current week' do
    end

    it 'displays the upcoming week' do
    end
  end

  describe 'signing up for an an accompaniment' do
  end

  describe 'canceling an RSVP for an accompaniment' do
  end
end