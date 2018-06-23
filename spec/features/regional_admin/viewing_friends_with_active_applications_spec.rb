require 'rails_helper'

RSpec.describe 'Regional Admin views friends with active applications', type: :feature do

  let(:regional_admin) { create :user, :regional_admin, community: community }
  let(:community) { create :community }
  let(:region) { community.region }
  let!(:friend) { create :friend, community: community, region: region }

  before do
    login_as(regional_admin)
  end

  describe 'friend with at least one active application and an assigned lawyer' do
    let!(:application) { create :application, friend: friend, status: 'in_review' }
    let!(:remote_clinic_lawyer) { create :user, :remote_clinic_lawyer }
    let!(:user_friend_association) { create :user_friend_association, user: remote_clinic_lawyer, friend: friend, remote: true }

    it 'is displayed in the "Friends with Active Appplications" section' do
      visit regional_admin_region_friends_path(region)
      within '#friends-with-active-applications' do
        expect(page).to have_link(friend.name)
      end
    end
  end

  describe 'friend with at least one active application and NO assigned lawyer' do
    let!(:application) { create :application, friend: friend, status: 'in_review' }

    it 'is NOT displayed in the "Friends with Active Applications" section' do
      visit regional_admin_region_friends_path(region)
      within '#friends-with-active-applications' do
        expect(page).to_not have_link(friend.name)
      end
    end
  end

  describe 'friend with NO active applications' do
    it 'is NOT displayed in the "Friends with Active Applications" section' do
      visit regional_admin_region_friends_path(region)
      within '#friends-with-active-applications' do
        expect(page).to_not have_link(friend.name)
      end
    end
  end
end
