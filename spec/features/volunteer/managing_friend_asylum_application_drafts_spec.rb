require 'rails_helper'

RSpec.describe 'Volunteer managing asylum application drafts for shared friends', type: :feature, js: true do

  let!(:volunteer) { create(:user, :volunteer, community: community) }
  let!(:shared_friend) { create(:friend, community: community) }
  let!(:not_shared_friend) { create(:friend, community: community) }
  let!(:user_friend_association) { create(:user_friend_association, friend: shared_friend, user: volunteer)}
  let!(:application) { create(:application, friend: shared_friend) }
  let!(:draft) { create(:draft, friend: shared_friend, application: application) }

  before do
    login_as(volunteer)
    visit root_path
    click_link 'Clinic'
  end

  describe 'primary community' do
    let(:community) { create :community, :primary }

    describe 'viewing shared friend records' do
      it 'displays friend records associated with the volunteer' do
        expect(page).to have_content(shared_friend.name)
      end

      it 'does not display friend records NOT associated with the volunteer' do
        expect(page).not_to have_content(not_shared_friend.name)
      end
    end

    describe 'managing friend applications' do
      before do
        click_link shared_friend.name
        click_link 'Documents'
      end

      it 'does not display status for primary community volunteer' do
        expect(page).not_to have_content('Submit for Review')
      end
    end
  end
end
