require 'rails_helper'

RSpec.describe FamilyMemberConstructor, type: :model do
  subject(:family_member_constructor) { build :family_member_constructor, relationship: relationship }
  let(:relationship) { 'spouse' }
  let(:spousal_relationship) { class_double('SpousalRelationship').
      as_stubbed_const(:transfer_nested_constants => true) }
  let(:parent_child_relationship) { class_double('ParentChildRelationship').
      as_stubbed_const(:transfer_nested_constants => true) }
  let(:partner_relationship) { class_double('PartnerRelationship').
      as_stubbed_const(:transfer_nested_constants => true) }

  it { should validate_presence_of(:friend_id) }
  it { should validate_presence_of(:relation_id) }
  it { should validate_presence_of(:relationship) }

  describe 'run' do
    context 'when the family member is a spouse' do
      it 'creates a new spousal relationship' do
        expect(spousal_relationship).to receive(:create).with(friend_id: family_member_constructor.friend_id, spouse_id: family_member_constructor.relation_id)
        family_member_constructor.run
      end
    end

    context 'when the family member is a parent' do
      let(:relationship) { 'parent' }
      it 'creates a new parent relationship' do
        expect(parent_child_relationship).to receive(:create).with(parent_id: family_member_constructor.relation_id, child_id: family_member_constructor.friend_id)
        family_member_constructor.run
      end
    end

    context 'when the family member is a child' do
      let(:relationship) { 'child' }
      it 'creates a new child relationship' do
        expect(parent_child_relationship).to receive(:create).with(parent_id: family_member_constructor.friend_id, child_id: family_member_constructor.relation_id)
        family_member_constructor.run
      end
    end

    context 'when the family member is a partner' do
      let(:relationship) { 'partner' }
      it 'creates a new partner relationship' do
        expect(partner_relationship).to receive(:create).with(friend_id: family_member_constructor.friend_id, partner_id:
        family_member_constructor.relation_id)
        family_member_constructor.run
      end
    end
  end
end
