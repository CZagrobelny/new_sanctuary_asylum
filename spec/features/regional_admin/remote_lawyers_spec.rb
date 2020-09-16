require 'rails_helper'

RSpec.describe 'Regional Admin manages lawyers', type: :feature do

  let(:regional_admin) { create :user, :regional_admin, community: community }
  let(:community) { create :community }
  let(:region) { community.region }
  let(:other_region) { create :region }
  let(:keeper) { create(:user, :remote_clinic_lawyer, first_name: 'Persistent', last_name: 'Record') }
  let(:deleteable) { create(:user, :remote_clinic_lawyer, first_name: 'Deleteable') }

  before do
    login_as(regional_admin)
  end

  describe 'index' do
    describe 'no remote lawyers' do
      before do
        @remote_lawyers = nil
      end

      it 'renders no lawyers text' do
        visit regional_admin_remote_lawyers_path
        expect(page).to have_content('No remote lawyers')
      end
    end

    describe 'has lawyers' do
      before do
        lawyer1 = create(:user, :remote_clinic_lawyer, first_name: 'Asha')
        lawyer2 = create(:user, :remote_clinic_lawyer, first_name: 'Robbie')
        @lawyers = [lawyer1, lawyer2]
      end

      it 'renders lawyers' do
        visit regional_admin_remote_lawyers_path
        expect(page).to have_content('Asha')
        expect(page).to have_content('Robbie')
      end
    end
  end

  describe 'edit' do
    before do
      keeper
    end

    it 'should render the proper form' do
      visit edit_regional_admin_remote_lawyer_path(keeper.id)
      expect(page).to have_content 'Edit Remote Clinic Lawyer'
    end

    it 'should successfully render a page' do
      visit regional_admin_remote_lawyers_path
      expect(page).to have_content('Persistent')
      within("tr#lawyer-#{keeper.id}") do
        # Delete is in Bootstrap dropdown so open that first
        find("a\#edit-lawyer-#{keeper.id}").click
      end
      expect(page).to have_content 'Edit Remote Clinic Lawyer'
    end

    it 'should successfully prefill the form' do
      visit regional_admin_remote_lawyers_path
      expect(page).to have_content('Persistent')
      within("tr#lawyer-#{keeper.id}") do
        # Delete is in Bootstrap dropdown so open that first
        find("a\#edit-lawyer-#{keeper.id}").click
      end
      expect(find_field('First Name').value).to eq 'Persistent'
    end
  end

  describe 'destroy' do
    before do
      deleteable
      keeper
    end

    it 'deletes when button is clicked' do
      visit regional_admin_remote_lawyers_path
      expect(page).to have_content('Deleteable')
      expect(page).to have_content('Persistent')

      within("tr#lawyer-#{deleteable.id}") do
        # Delete is in Bootstrap dropdown so open that first
        find('button').click
        click_link 'Delete'
      end
      expect(page).to_not have_content('Deleteable')
    end
  end
end
