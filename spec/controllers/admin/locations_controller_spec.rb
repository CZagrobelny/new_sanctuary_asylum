require 'rails_helper'

RSpec.describe Admin::LocationsController, type: :controller do
  it { should route(:get, '/admin/locations').to(action: :index) }
  it { should route(:get, '/admin/locations/new').to(action: :new) }
  it { should route(:post, '/admin/locations').to(action: :create) }

  describe 'requests' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:require_admin).and_return(true)
      allow(controller).to receive(:log_action).and_return(true)
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
          expect(flash.now[:error]).to eq "Something went wrong :("
        end

      end

    end
  end
end
