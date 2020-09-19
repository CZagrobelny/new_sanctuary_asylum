require 'rails_helper'

RSpec.describe RegionalAdmin::RemoteLawyersController, type: :controller do

  let(:regional_admin) { create :user, :regional_admin, community: community }
  let!(:community) { create :community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(regional_admin)
  end

  describe 'GET #index' do
    describe 'when no lawyers' do
      let(:remote_lawyers) { nil }

      it 'returns no lawyers' do
        get :index
        expect(response.successful?).to eq true
      end
    end
  end

  describe 'GET #edit' do
    let!(:user) { create(:user, :remote_clinic_lawyer, first_name: 'Hello') }

    it 'returns a successful page' do
      get :edit, params: {id: user.id }
      expect(response.successful?).to eq true
    end
  end

  describe 'PUT #update' do
    let!(:user) { create(:user, :remote_clinic_lawyer, first_name: 'Hello') }

    it 'update of a lawyer is successful' do
      put :update, params: { id: user.id, remote_lawyer: { first_name: 'Goodbye' } }
      udpated_user = User.find(user.id)
      expect(udpated_user.first_name).to eq 'Goodbye'
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create :user }

    it 'deletes user' do
      user_count = User.count
      delete :destroy, params: { id: user.id }
      expect(User.count).to eq user_count - 1
    end
  end
end
