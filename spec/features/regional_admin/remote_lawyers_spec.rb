require 'rails_helper'

RSpec.describe 'Regional Admin manages lawyers', type: :feature do

  let(:regional_admin) { create :user, :regional_admin, community: community }
  let(:community) { create :community }
  let(:region) { community.region }
  let(:other_region) { create :region }

  before do
    login_as(regional_admin)
  end

  describe 'index' do
    it 'page renders' do
      visit regional_admin_remote_lawyers_path
      expect(page).to have_link('Invite a user')
    end

    describe 'no lawyers' do
      before do
        @lawyers = nil
      end

      it 'renders no lawyers text' do
        visit regional_admin_remote_lawyers_path
        expect(page).to have_content('No remote lawyers')
      end
    end

    describe 'has lawyers' do
      before do
        lawyer1 = create(:user, first_name: 'Asha', remote_clinic_lawyer: true)
        lawyer2 = create(:user, first_name: 'Robbie', remote_clinic_lawyer: true)
        @lawyers = [lawyer1, lawyer2]
      end

      it 'renders lawyers' do
        visit regional_admin_remote_lawyers_path
        expect(page).to have_content('Asha')
        expect(page).to have_content('Robbie')
      end
    end
  end
end
