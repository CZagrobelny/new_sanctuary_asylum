require 'rails_helper'

RSpec.describe Admin::SanctuariesController, type: :controller do
  it { should route(:get, '/admin/sanctuaries').to(action: :index) }
  it { should route(:get, '/admin/sanctuaries/new').to(action: :new) }
  it { should route(:post, '/admin/sanctuaries').to(action: :create) }

  describe 'requests' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:require_admin).and_return(true)
      allow(controller).to receive(:log_action).and_return(true)
    end

    describe 'GET /admin/sanctuaries' do
      before do
        expect(Sanctuary).to receive(:order)
                           .with('name ASC')
                           .and_return(double(:paginate => [build(:sanctuary), build(:sanctuary)]))
        get :index
      end

      it { should respond_with(:success) }

      it 'assigns @sanctuaries' do
        expect(controller.instance_variable_get('@sanctuaries').length).to eq 2
      end
    end

    describe 'GET /admin/sanctuaries/new' do
      before { get :new }
      it { should respond_with(:success) }
    end

    describe 'POST /admin/sanctuaries' do
      context 'valid params' do
        let(:params) { { sanctuary: {name: 'name', leader_name: 'leader_name'} } }

        it 'creates a new sanctuary' do
          expect {
            post :create, params: params
          }.to change { Sanctuary.count }.by(1)
        end

        it 'redirects to admin_sanctuaries_path' do
          post :create, params: params
          expect(response).to have_http_status 302
          expect(response.location).to include '/admin/sanctuaries'
        end
      end

      context 'invalid params' do
        let(:params) { { sanctuary: {name: '', leader_name: ''} } }

        it 'does not create a new location' do
          expect {
            post :create, params: params
          }.not_to change { Sanctuary.count }
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

    describe 'GET /admin/sanctuaries/:id/edit' do
      before do
        @sanctuary = create(:sanctuary)
        get :edit, params: { id: @sanctuary.id }
      end

      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end

    describe 'PATCH /admin/sanctuaries/1' do
      context 'valid params' do
        before do
          @sanctuary = create(:sanctuary)
          patch :update, params: { id: @sanctuary.id, sanctuary: { name: 'new name' } }
        end

        it 'can change the name' do
          expect(Sanctuary.find(@sanctuary.id).name).not_to eq @sanctuary.name
        end

        it { should redirect_to(admin_sanctuaries_path) }
      end

      context 'invalid params' do
        let(:sanctuary) { create(:sanctuary) }
        let(:params) { { id: sanctuary.id, sanctuary: {name: '', leader_name: ''} } }

        before do
          @sanctuary = sanctuary
        end

        it 'does not create a new location' do
          expect {
            patch :update, params: params
          }.not_to change { Sanctuary.count }
        end

        it 'renders "edit" ' do
          patch :update, params: params
          expect(response).to render_template(:edit)
        end

        it 'sets flash' do
          patch :update, params: params
          expect(flash.now[:error]).to eq "Something went wrong :("
        end
      end
    end
  end
end
