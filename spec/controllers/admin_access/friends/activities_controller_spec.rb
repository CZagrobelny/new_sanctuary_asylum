require 'rails_helper'

RSpec.describe Admin::Friends::ActivitiesController, type: :controller do
  let!(:community) { create :community, :primary }
  let(:community_admin) { create :user, :community_admin, community: community }
  let(:friend) { create :friend, community: community }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(community_admin)
  end

  describe "accessing a activity's info" do
    context 'when the community is primary' do
			describe 'POST #create' do
			let!(:activity) { create :activity, region: community.region, confirmed: true, last_edited_by: community_admin.id }
        it 'allows access' do
            activity_count = Activity.count
            post :create, params: { community_slug: community.slug, friend_id: friend.id, activity: activity.attributes }, format: 'js'
						expect(Activity.count).to eq activity_count + 1
						expect(Activity.last.last_edited_by).to eq community_admin.id
        end
    	end
		end
	end

	describe 'PUT #update' do
		let!(:activity) { create :activity, region: community.region, confirmed: true, last_edited_by: community_admin.id }
			it 'allows access' do
                    friend.activities << activity
                    activity_attributes = activity.attributes
					activity_attributes['notes'] = 'test test test'
					put :update, params: { community_slug: community.slug, friend_id: friend.id, id: activity.id, activity: activity_attributes }, format: 'js'
					expect(activity.reload.notes).to eq 'test test test'
					expect(activity.reload.last_edited_by).to eq community_admin.id
				end
  end
end