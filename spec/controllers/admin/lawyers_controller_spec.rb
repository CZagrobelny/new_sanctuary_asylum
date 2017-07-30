require 'rails_helper'

RSpec.describe Admin::LawyersController, type: :controller do
  it { should route(:get, '/admin/lawyers').to(action: :index) }
  it { should route(:get, '/admin/lawyers/new').to(action: :new) }
  it { should route(:post, '/admin/lawyers').to(action: :create) }

  describe 'requests' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:require_admin).and_return(true)
    end

    describe 'GET /admin/lawyers' do
      before do
        expect(Lawyer).to receive(:order)
                           .with('created_at desc')
                           .and_return(double(:paginate => [build(:lawyer), build(:lawyer)]))
        get :index
      end
    
      it { should respond_with(:success) }
      
      it 'assigns @lawyers' do
        expect(controller.instance_variable_get('@lawyers').length).to eq 2
      end
    end

    describe 'GET /admin/lawyers/new' do
      before { get :new } 
      it { should respond_with(:success) }
    end

    describe 'GET /admin/lawyers/:id/edit' do
      before do
        @lawyer = create(:lawyer)
        get :edit, params: { id: @lawyer.id }
      end

      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end

    describe 'POST /admin/lawyers/1' do
      before do
        @lawyer = create(:lawyer)
        post :update, params: { id: @lawyer.id, lawyer: { first_name: @lawyer.first_name, last_name: FFaker::Name.last_name } } 
      end

      it 'can change the last name' do
        expect(Lawyer.find(@lawyer.id).last_name).not_to eq @lawyer.last_name
      end

      it { should redirect_to(admin_lawyers_path) }

    end

    describe 'POST /admin/lawyers' do
      context 'valid params' do
        let(:params) { { lawyer: {first_name: 'first', last_name: 'last' } } }

        it 'creates a new lawyer' do
          expect {
            post :create, params: params
          }.to change { Lawyer.count }.by(1)
        end
        
        it 'redirects to admin_lawyers_path' do
          post :create, params: params
          expect(response).to have_http_status 302
          expect(response.location).to include '/admin/lawyers'  
        end
      end

      context 'missing first name' do
        let(:params) { { lawyer: {last_name: 'last' } } }
        
        it 'does not create a new lawyer' do
          expect {
            post :create, params: params
          }.not_to change { Lawyer.count }
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
  end
end
