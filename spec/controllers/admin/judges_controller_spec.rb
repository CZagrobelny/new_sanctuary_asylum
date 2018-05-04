require 'rails_helper'

RSpec.describe Admin::JudgesController, type: :controller do
  it { should route(:get, '/admin/judges').to(action: :index) }
  it { should route(:get, '/admin/judges/new').to(action: :new) }
  it { should route(:post, '/admin/judges').to(action: :create) }

  describe 'requests' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:require_admin).and_return(true)
      allow(controller).to receive(:log_action).and_return(true)
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

    describe 'GET /admin/judges/new' do
      before { get :new }
      it { should respond_with(:success) }
    end

    describe 'GET /admin/judges/:id/edit' do
      before do
        @judge = create(:judge)
        get :edit, params: { id: @judge.id }
      end

      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end

    describe 'POST /admin/judges/1' do
      before do
        @judge = create(:judge)
      end

      context 'valid params' do
        before do
          post :update, params: { id: @judge.id, judge: { last_name: 'Changed' } }
        end

        it 'can change the last name' do
          expect(Judge.find(@judge.id).last_name).to eq 'Changed'
        end

        it { should redirect_to(admin_judges_path) }
      end


      context 'invalid params' do
        before do
          post :update, params: { id: @judge.id, judge: { last_name: '' } }
        end

        it 'does not change the last name' do
          expect(Judge.find(@judge.id).last_name).to eq @judge.last_name
        end

        it 'renders "edit"' do
          expect(response).to render_template(:edit)
        end

        it 'sets flash' do
          expect(flash.now[:error]).to eq "Something went wrong :("
        end
      end
    end

    describe 'POST /admin/judges' do
      context 'valid params' do
        let(:params) { { judge: {first_name: 'first', last_name: 'last' } } }

        it 'creates a new judge' do
          expect {
            post :create, params: params
          }.to change { Judge.count }.by(1)
        end

        it 'redirects to admin_judges_path' do
          post :create, params: params
          expect(response).to have_http_status 302
          expect(response.location).to include '/admin/judges'
        end
      end

      context 'missing first name' do
        let(:params) { { judge: {last_name: 'last' } } }

        it 'does not create a new judge' do
          expect {
            post :create, params: params
          }.not_to change { Judge.count }
        end

        it 'renders "new"' do
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
