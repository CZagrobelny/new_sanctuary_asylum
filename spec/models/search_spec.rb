require 'rails_helper'

RSpec.describe Search, type: :model do
  context "Searching for users" do
    let!(:user1) { create :user }  
    let!(:user2) { create :user }

    it "returns the expected users" do
      expect(
        Search.new("user", user1.first_name).perform
      ).to eq [user1]
    end
  end

  context "Searching for friends" do
    let!(:friend1) { create :friend }
    let!(:friend2) { create :friend }

    it "returns the expected friends if one word is passed" do
      expect(
        Search.new("friend", friend1.last_name).perform
      ).to eq [friend1]
    end

    it "returns the expected friends if two words are passed" do
      expect(
        Search.new("friend", friend1.name).perform
      ).to eq [friend1]
    end

  end
end
