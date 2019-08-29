require "rails_helper"

RSpec.describe "admin/users/edit" do
    context 'when the current user has accompaniments' do
            newUser = FactoryBot.create(:user)
            newFriend = FactoryBot.create(:friend)
            newAct = FactoryBot.create(:activity)
            newAcc = FactoryBot.create(:accompaniment)
            let (:user) {newUser}
            let (:accompaniment) {newAcc}
        it 'displays the accompaniments and associated links to friends' do
    
 

            render

            expect(rendered).to have_link 'Accompanied Friend', href: edit_community_admin_friend_path(newUser.community.slug, newAcc.friend)
        end
    end
end