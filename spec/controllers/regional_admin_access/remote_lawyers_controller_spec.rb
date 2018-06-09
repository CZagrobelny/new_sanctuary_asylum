require 'rails_helper'

RSpec.describe RegionalAdmin::RemoteLawyersController, type: :controller do

  let(:regional_admin) { create :user, :regional_admin, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(regional_admin)
  end

  describe 'GET #index' do
    describe 'when no lawyers' do
      let(:remote_lawyers) { nil }
      let!(:community) { create :community }

      it 'returns no lawyers' do
        get :index
        expect(response.success?).to eq true
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create :user }
    let!(:community) { create :community }

    it 'deletes user' do
      user_count = User.count
      delete :destroy, params: { id: user.id }
      expect(User.count).to eq user_count - 1
    end
  end
end
