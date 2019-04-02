require 'rails_helper'

RSpec.describe 'Remote clinic volunteer uploads a draft', type: :feature, js: true do
  let(:community) { create(:community) }
  let(:volunteer) { create(:user, :volunteer, community: community) }
  let!(:release) { create(:release, friend: friend) }
  let(:friend) { create(:friend, community: community) }
  let!(:user_friend_association) { create(:user_friend_association, friend: friend, user: volunteer)}

  before do
    login_as(volunteer)
    visit root_path
    click_link 'Clinic'
    click_link friend.name
  end

  context 'there is not a remote clinic lawyer assigned to the friend yet' do
    scenario 'upload a draft and submit for review; should email the regional admin' do
      upload_draft_and_submit

      # TODO: regional admin should get an email 'Lawyer Assignment Needed'
    end
  end

  context 'there is a remote clinic lawyer assigned to the friend' do
    let!(:remote_clinic_lawyer) { create(:user, :remote_clinic_lawyer) }
    let!(:lawyer_friend_assocition) { create(:user_friend_association, user: remote_clinic_lawyer, friend: friend, remote: true) }

    scenario 'upload a draft and submit for review; should email the remote clinic lawyer' do
      upload_draft_and_submit

      # TODO: remote clinic lawyer should get an email 'Review needed'
    end
  end

  def upload_draft_and_submit
    click_link 'Documents'
    expect(page).to have_content 'There are no files associated with this user.'
    click_on 'Create Document'
    expect(page).to have_content 'New Document'
    attach_file 'File Upload', Rails.root.join('spec', 'support', 'images', 'nsc_logo.png'), make_visible: true
    select 'Asylum', from: 'application[category]'
    # TODO
    # add self to volunteers list
    # Save; should land back on Documents tab
    # should see Submit For Review button
    # click Submit For Review
    # should see In Review
  end
end
