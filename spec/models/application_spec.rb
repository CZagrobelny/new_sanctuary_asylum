require 'rails_helper'

RSpec.describe Application, type: :model do
  subject(:application) { build :application }

  describe "#validate_category_uniquness" do
    context "the category is unique to the friend" do
      it "returns true" do
        expect(application.save).to eq true
      end
    end
    context "the category is not unique to the friend" do
      let!(:duplicate_application) { create :application, friend: application.friend }
      it "returns false" do
        expect(application.save).to eq false
      end
    end
  end
end
