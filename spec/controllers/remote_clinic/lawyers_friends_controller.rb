require 'rails_helper'

RSpec.describe RemoteClinic::Lawyers::FriendsController, type: :controller do

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe '#index' do
    describe 'user is a remote clinic lawyer' do
      let(:lawyer) { create(:user, :remote_clinic_lawyer) }
      before { allow(controller).to receive(:current_user).and_return(lawyer) }

      it "renders index page" do
        get :index, params: { user_id: lawyer.id }
        expect(response.successful?).to eq true
      end
    end
  end

  describe '#show' do
    describe 'lawyer does not have access to friend' do
      let(:friend) { create(:friend) }
      let(:volunteer) { create(:user) }
      before { allow(controller).to receive(:current_user).and_return(volunteer) }

      it 'does not allow access' do
        expect { get :show, params: { user_id: volunteer.id, id: friend.id } }.to raise_error('Not Found')
      end
    end

    describe 'lawyer has access to friend' do
      let(:friend) { create(:friend) }
      let(:lawyer) { create(:user, :remote_clinic_lawyer) }
      let!(:friendship) { create(:user_friend_association, user: lawyer, friend: friend)}
      before { allow(controller).to receive(:current_user).and_return(lawyer) }

      it "renders show page" do
        get :show, params: { user_id: lawyer.id, id: friend.id }
        expect(response.successful?).to eq true
      end
    end
  end
end
