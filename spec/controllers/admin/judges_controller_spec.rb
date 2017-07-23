require 'rails_helper'

RSpec.describe Admin::JudgesController, type: :controller do
  it { should route(:get, '/admin/judges').to(action: :index) }
  it { should route(:delete, '/admin/judges/123').to(action: :destroy, id: '123') }

  describe 'requests' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:require_admin).and_return(true)
    end

    describe 'GET /admin/judges' do
      before do
        expect(Judge).to receive(:order)
                           .with('created_at desc')
                           .and_return(double(:paginate => [build(:judge), build(:judge)]))
        get :index
      end
    
      it { should respond_with(:success) }
      
      it 'assigns @judges' do
        expect(controller.instance_variable_get('@judges').length).to eq 2
      end
    end

    describe 'DELETE /admin/judges/id' do
      
      before do
        @judge = create(:judge)
        expect(Judge).to receive(:find).with('123').and_return(@judge)
        @delete_request = proc { delete :destroy, params: {id: '123'} }
      end

      it 'removes a judge' do
        expect(&@delete_request).to change { Judge.count }.by(-1)
      end
      
      it 'redirects to judges index' do
        @delete_request.call
        expect(response).to have_http_status 302
        expect(response.location).to include '/admin/judges'
      end

      it 'sets success flash' do
        @delete_request.call
        expect(flash[:success].present?).to be true
        expect(flash[:error].present?).to be false
      end

      it 'sets failure flash' do
        expect(@judge).to receive(:destroy).and_return(false)
        @delete_request.call
        expect(flash[:success].present?).to be false
        expect(flash[:error].present?).to be true
      end
    end
  end
end
