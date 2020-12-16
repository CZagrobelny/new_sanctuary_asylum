require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe 'Friend edit other case info', type: :feature, js: true do
  describe 'non-primary community' do
    let(:community) { create :community }
    let(:community_admin) { create(:user, :community_admin, community: community) }
    let(:friend) { create(:friend, community: community) }
    let!(:social_work_referral_categories) {
      [
        esl_social_work_referral_category,
        create(:social_work_referral_category, name: 'IDNYC')
      ]
    }
    let(:esl_social_work_referral_category) { create(:social_work_referral_category, name: 'ESL') }

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

    describe 'selecting referral category' do
      context 'friend with no category' do
        it 'saves category' do
          select 'ESL', from:'friend_social_work_referral_category_ids'
          click_button 'Save'
          selected_value = page.evaluate_script("$('#friend_social_work_referral_category_ids').val()")
          expect(selected_value).to eq [esl_social_work_referral_category.id.to_s]
        end
      end
    end
  end
end
