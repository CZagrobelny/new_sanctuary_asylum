require 'rails_helper'

RSpec.describe FamilyRelationship, type: :model do
  let(:friend) { create :friend }
  let(:relation) { create :friend }
  let(:relationship_type) { %w(spouse child parent sibling partner).sample }
  let(:reciprocal_relationship_type_collection) do
    HashWithIndifferentAccess.new(spouse: 'spouse',
      child: 'parent',
      parent: 'child',
      sibling: 'sibling',
      partner: 'partner')
  end
  let(:reciprocal_relationship_type) { reciprocal_relationship_type_collection[relationship_type] }
  let(:family_relationship_params) do
    { friend_id: friend.id, relation_id: relation.id, relationship_type: relationship_type }
  end
  let(:reciprocal_family_relationship_params) do
    { friend_id: relation.id, relation_id: friend.id, relationship_type: reciprocal_relationship_type }
  end

  describe '#create' do
    context 'when all required attributes are present' do
      context 'when there is NO existing family_relationship between the Friend and Relation' do
        it 'creates a family relationship' do
          expect(FamilyRelationship.where(family_relationship_params).count).to eq 0
          FamilyRelationship.create(family_relationship_params)
          expect(FamilyRelationship.where(family_relationship_params).count).to eq 1
        end

        it 'creates a reciprocal family relationship' do
          expect(FamilyRelationship.where(reciprocal_family_relationship_params).count).to eq 0
          FamilyRelationship.create(family_relationship_params)
          expect(FamilyRelationship.where(reciprocal_family_relationship_params).count).to eq 1
        end
      end

      context 'when there is an existing family relationship between the Friend and the Relation' do
        before do
          FamilyRelationship.create!(friend_id: friend.id,
            relation_id: relation.id,
            relationship_type: relationship_type)
        end

        it 'does NOT create any family relationships' do
          expect{ FamilyRelationship.create(family_relationship_params) }.to_not change{ FamilyRelationship.count }
        end

        it 'adds an error to the family relationship' do
          family_relationship = FamilyRelationship.create(family_relationship_params)
          expect(family_relationship.errors.full_messages).to include('Relation is already listed as a family member for this friend')
        end
      end
    end
  end

  context 'when a required attribute is NOT present' do
    let(:relationship_type) { nil }
    it 'does NOT create any family relationships' do
      expect{ FamilyRelationship.create(family_relationship_params) }.to_not change{ FamilyRelationship.count }
    end

    it 'adds a error to the family relationship' do
      family_relationship = FamilyRelationship.create(family_relationship_params)
      expect(family_relationship.errors.full_messages).to include("Relationship type can't be blank")
    end
  end

  describe '#destroy' do
    it 'destroys the family relationship AND the reciprocal family relationship' do
      family_relationship = FamilyRelationship.create(family_relationship_params)
      expect(FamilyRelationship.where(family_relationship_params).count).to eq 1
      expect(FamilyRelationship.where(reciprocal_family_relationship_params).count).to eq 1
      family_relationship.destroy
      expect(FamilyRelationship.where(family_relationship_params).count).to eq 0
      expect(FamilyRelationship.where(reciprocal_family_relationship_params).count).to eq 0
    end
  end
end
