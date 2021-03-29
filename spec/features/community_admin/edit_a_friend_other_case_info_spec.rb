require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe 'Friend edit other case info', type: :feature, js: true do
  describe 'non-primary community' do
    let(:community) { create :community }
    let(:community_admin) { create(:user, :community_admin, community: community) }
    let(:friend) { create(:friend, community: community) }

    before do
      3.times { create(:friend, community: community) }
      login_as(community_admin)
      visit edit_community_admin_friend_path(community, friend)

      within '.nav-tabs' do
        click_link 'Other Case Info'
      end
    end

    describe 'editing "Other Case Info"' do
      it 'displays the "Other Case Info" tab' do
        within '.tab-content' do
          expect(page).to have_content 'Lawyer'
        end
      end
    end
  end
end
