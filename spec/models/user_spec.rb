require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build :user }

  describe '#can_access_community?(community)' do
    context 'when the user is a regional admin' do
      let(:user) { create :user, :regional_admin }
      context "when the user's regions include the community region" do
        let(:community) { create :community, region: user.regions.first }
        it 'returns true' do
          expect(user.can_access_community?(community)).to eq true
        end
      end

      context "when the user's regions do NOT include the community region" do
        let(:community) { create :community }
        it 'returns false' do
          expect(user.can_access_community?(community)).to eq false
        end
      end
    end

    context 'when the user is NOT a regional admin' do
      let(:user) { create :user }
      context "when the user's community is the community" do
        let(:community) { user.community }
        it 'returns true' do
          expect(user.can_access_community?(community)).to eq true
        end
      end

      context "when the user's community is NOT the community" do
        let(:community) { create :community }
        it 'returns false' do
          expect(user.can_access_community?(community)).to eq false
        end
      end
    end
  end

  describe '#can_access_region?(region)' do
    context "when the user's regions include the region" do
      let(:user) { create :user, :regional_admin }
      let(:region) { user.community.region }
      it 'returns true' do
        expect(user.can_access_region?(region)).to eq true
      end
    end

    context "when the user's regions do NOT include the region" do
      let(:user) { create :user, :regional_admin }
      let(:region) { create :region }
      it 'returns false' do
        expect(user.can_access_region?(region)).to eq false
      end
    end
  end

  describe '#regional_admin?' do
    context 'when the user is NOT an admin but does have a region' do
      let(:user) { create :user, :volunteer }
      before { create :user_region, user: user, region: user.community.region }
      it 'returns false' do
        expect(user.regional_admin?).to eq false
      end
    end

    context 'when the user does NOT have access any regions but is an admin' do
      let(:user) { create :user, :community_admin }
      it 'returns false' do
        expect(user.regional_admin?).to eq false
      end
    end

    context 'when the user is an admin and has access to at least one region' do
      let(:user) { create :user, :regional_admin }
      it 'returns true' do
        expect(user.regional_admin?).to eq true
      end
    end
  end

  describe '#existing_relationship?' do
    let(:friend) { create(:friend) }
    let(:user) { create :user, :volunteer }

    context 'when relationship does not exist' do
      it 'returns false' do
        expect(user.existing_relationship?(friend)).to eq false
      end
    end

    context 'when relationship exists' do
      let!(:friendship) { create(:user_friend_association, user: user, friend: friend) }

      it 'returns true' do
        expect(user.existing_relationship?(friend)).to eq true
      end
    end
  end
end
