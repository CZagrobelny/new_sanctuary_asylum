require 'rails_helper'

RSpec.describe Admin::JudgesController, type: :controller do
  it { should route(:get, '/admin/judges').to(action: :index) }

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
  end
end
