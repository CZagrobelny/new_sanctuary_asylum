require 'rails_helper'

RSpec.describe 'User accepts an invitation to create a new account', type: :feature do

  #Need to find a good way to invite. It seems like the invitation token is not the same as whats in the email, so might have to pull these out of the email. that feels messy.  may also put this together with invites.
  let(:invited_user) { User.invite!(:email => 'someone@example.com') }
  let(:first_name) { FFaker::Name.first_name }
  let(:last_name) { FFaker::Name.last_name }

  describe 'a user accepting an invitation to create an account' do
    before do
      visit accept_user_invitation_path(invitation_token: invited_user.reload.invitation_token)
    end

    scenario 'with valid information' do
      fill_in 'First Name', with: first_name

      it 'signs in the user' do
      end
      expect(current_path).to eq dashboard_path
    
    end

    scenario 'with invalid information' do
      it 'does not sign in the user' do
      end

      it 'displays validation errors' do
      end
    end
  end    
end