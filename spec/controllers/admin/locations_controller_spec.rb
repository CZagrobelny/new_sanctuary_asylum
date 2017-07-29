require 'rails_helper'

RSpec.describe Admin::LocationsController, type: :controller do
  it { should route(:get, '/admin/locations').to(action: :index) }
  it { should route(:get, '/admin/locations/new').to(action: :new) }
  it { should route(:post, '/admin/locations').to(action: :create) }
  it { should route(:delete, '/admin/locations/123').to(action: :destroy, id: '123') }

  describe 'requests' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:require_admin).and_return(true)
    end

    describe 'GET /admin/locations' do
      before do
        expect(Location).to receive(:order)
                           .with('created_at desc')
                           .and_return(double(:paginate => [build(:location), build(:location)]))
        get :index
      end
    
      it { should respond_with(:success) }
      
      it 'assigns @locations' do
        expect(controller.instance_variable_get('@locations').length).to eq 2
      end
    end

    describe 'GET /admin/locations/new' do
      before { get :new } 
      it { should respond_with(:success) }
    end

    describe 'GET /admin/locations/:id/edit' do
      before do
        @location = create(:location)
        get :edit, params: { id: @location.id }
      end

      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end

    describe 'POST /admin/locations/1' do
      before do
        @location = create(:location)
        post :update, params: { id: @location.id, location: { name: 'new name' } } 
      end

      it 'can change the name' do
        expect(Location.find(@location.id).name).not_to eq @location.name
      end

      it { should redirect_to(admin_locations_path) }

    end

    describe 'POST /admin/locations' do
      context 'valid params' do
        let(:params) { { location: {name: 'name'} } }

        it 'creates a new location' do
          expect {
            post :create, params: params
          }.to change { Location.count }.by(1)
        end
        
        it 'redirects to admin_locations_path' do
          post :create, params: params
          expect(response).to have_http_status 302
          expect(response.location).to include '/admin/locations'  
        end
      end

      context 'missing name' do
        let(:params) { { location: {name: ''} } }
        
        it 'does not create a new location' do
          expect {
            post :create, params: params
          }.not_to change { Location.count }
        end

        it 'renders "new" ' do
          post :create, params: params
          expect(response).to render_template(:new)
        end

        it 'sets flash' do
          post :create, params: params
          expect(flash[:error]).to eq "Something went wrong :("
        end

      end

    end

    describe 'DELETE /admin/locations/id' do
      
      before do
        @location = create(:location)
        expect(Location).to receive(:find).with('123').and_return(@location)
        @delete_request = proc { delete :destroy, params: {id: '123'} }
      end

      it 'removes a location' do
        expect(&@delete_request).to change { Location.count }.by(-1)
      end
      
      it 'redirects to locations index' do
        @delete_request.call
        expect(response).to have_http_status 302
        expect(response.location).to include '/admin/locations'
      end

      it 'sets success flash' do
        @delete_request.call
        expect(flash[:success].present?).to be true
        expect(flash[:error].present?).to be false
      end

      it 'sets failure flash' do
        expect(@location).to receive(:destroy).and_return(false)
        @delete_request.call
        expect(flash[:success].present?).to be false
        expect(flash[:error].present?).to be true
      end
    end
  end
end
