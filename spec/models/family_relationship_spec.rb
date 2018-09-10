require 'rails_helper'

RSpec.describe FamilyRelationship, type: :model do
  let(:friend) { create :friend }
  let(:relation) { create :friend }
  let(:relationship_type) { %w(spouse child parent sibling partner).sample }
  let(:reciprocal_relationship_collection) do
    HashWithIndifferentAccess.new(spouse: 'spouse',
      child: 'parent',
      parent: 'child',
      sibling: 'sibling',
      partner: 'partner')
  end
  let(:reciprocal_relationship_type) { reciprocal_relationship_collection[relationship_type] }

  describe '#create' do
    context 'when all required attributes are present' do
      context 'when there is NO existing family_relationship between the Friend and Relation' do
        it 'creates a family relationship' do
          expect(FamilyRelationship.where(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type).count).to eq 0
          FamilyRelationship.create(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type)
          expect(FamilyRelationship.where(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type).count).to eq 1
        end

        it 'creates a reciprocal family relationship' do
          expect(FamilyRelationship.where(friend_id: relation.id, relation_id: friend.id, relationship_type: relationship_type).count).to eq 0
          FamilyRelationship.create(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type)
          expect(FamilyRelationship.where(friend_id: relation.id, relation_id: friend.id, relationship_type: reciprocal_relationship_type).count).to eq 1
        end

        it 'associates the family relationship WITH the reciprocal family relationship' do
          FamilyRelationship.create(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type)
          family_relationship = FamilyRelationship.where(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type).first
          reciprocal_family_relationship = FamilyRelationship.where(friend_id: relation.id, relation_id: friend.id, relationship_type: reciprocal_relationship_type).first
          expect(family_relationship.reciprocal_relationship_id).to eq reciprocal_family_relationship.id
          expect(reciprocal_family_relationship.reciprocal_relationship_id).to eq family_relationship.id
        end
      end

      context 'when there is an existing family relationship between the Friend and the Relation' do
        before { FamilyRelationship.create!(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type) }

        it 'does NOT create any family relationships' do
          expect{ FamilyRelationship.create(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type) }.to_not change{ FamilyRelationship.count }
        end

        it 'adds an error to the family relationship' do
          family_relationship = FamilyRelationship.create(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type)
          expect(family_relationship.errors.full_messages).to include('Relation has already been taken')
        end
      end
    end
  end

  context 'when a required attribute is NOT present' do
    it 'does NOT create any family relationships' do
      expect{ FamilyRelationship.create(friend_id: friend.id, relation_id: relation.id, relationship_type: nil) }.to_not change{ FamilyRelationship.count }
    end

    it 'adds a error to the family relationship' do
      family_relationship = FamilyRelationship.create(friend_id: friend.id, relation_id: relation.id, relationship_type: nil)
        expect(family_relationship.errors.full_messages).to include("Relationship type can't be blank")
    end
  end

  describe '#destroy' do
    it 'destroys the family relationship AND the reciprocal family relationship' do
      family_relationship = FamilyRelationship.create(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type)
      expect(FamilyRelationship.where(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type).count).to eq 1
      expect(FamilyRelationship.where(friend_id: relation.id, relation_id: friend.id, relationship_type: reciprocal_relationship_type).count).to eq 1
      family_relationship.destroy
       expect(FamilyRelationship.where(friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type).count).to eq 0
      expect(FamilyRelationship.where(friend_id: relation.id, relation_id: friend.id, relationship_type: reciprocal_relationship_type).count).to eq 0
    end
  end
end
