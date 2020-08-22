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

  scenario 'upload a draft' do
    click_link 'Documents'
    expect(page).to have_content 'There are no files associated with this user.'
    click_on 'Create Document'
    expect(page).to have_content 'New Document'
    attach_file 'File Upload', Rails.root.join('spec', 'support', 'images', 'nsc_logo.png'), make_visible: true
    select 'Asylum', from: 'application[category]'
    click_on 'Save'
    expect(page).to have_content 'Application draft saved'
  end
end
