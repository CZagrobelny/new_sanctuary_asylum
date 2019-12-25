require 'rails_helper'

RSpec.describe 'Remote clinic volunteer uploads a draft', type: :feature, js: true do
  let(:region) { create(:region) }
  let(:community) { create(:community, region: region) }
  let!(:regional_admin) { create(:user, :regional_admin, community: community) }
  let(:volunteer) { create(:user, :volunteer, community: community) }
  let(:friend) { create(:friend, community: community, region: region) }
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

      open_email(regional_admin.email)
      expect(current_email.subject).to eq 'Lawyer assignment needed'
    end
  end

  context 'there is a remote clinic lawyer assigned to the friend' do
    let!(:remote_clinic_lawyer) { create(:user, :remote_clinic_lawyer) }
    let!(:lawyer_friend_assocition) { create(:user_friend_association, user: remote_clinic_lawyer, friend: friend, remote: true) }

    scenario 'upload a draft and submit for review; should email the remote clinic lawyer' do
      upload_draft_and_submit

      open_email(remote_clinic_lawyer.email)
      expect(current_email.subject).to eq 'Review needed'
    end
  end

  def upload_draft_and_submit
    # Upload a new document
    click_link 'Documents'
    expect(page).to have_content 'There are no files associated with this user.'
    click_on 'Create Document'
    expect(page).to have_content 'New Document'
    attach_file 'File Upload', Rails.root.join('spec', 'support', 'images', 'nsc_logo.png'), make_visible: true
    select 'Asylum', from: 'application[category]'

    # Add self as a volunteer
    find('#draft_user_ids_chosen').click
    within('.chosen-results') do
      find('li', text: volunteer.name).click
    end
    within('.chosen-choices') do
      expect(page).to have_content volunteer.name
    end

    # Save and submit for review
    click_on 'Save'
    expect(page).to have_content 'Application draft saved'
    click_on 'Submit for Review'
    within('span.status') do
      expect(page).to have_content 'In review'
    end
  end
end
