require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '#sanitize_query' do
    let(:search) { Search.new("friend", query, 1) }
    context 'when the query contains multiple blank spaces' do
      let(:query) {'  too   many  spaces  '}
      it 'returns a string without extraneous blank spaces' do
        expect(search.send(:sanitize_query)).to eq('too|many|spaces')
      end
    end

    context 'when the query contains the special character "!"' do
      let(:query) {'exclamation point !'}
      it 'returns a string that does not contain the special character' do
        expect(search.send(:sanitize_query)).to eq('exclamation|point')
      end
    end

    context 'when the query contains the special character "&"' do
      let(:query) {'ampers&and'}
      it 'returns a string that does not contain the special character' do
        expect(search.send(:sanitize_query)).to eq('ampersand')
      end
    end

    context 'when the query contains the special character "|"' do
      let(:query) {'|or|'}
      it 'returns a string that does not contain the special character' do
        expect(search.send(:sanitize_query)).to eq('or')
      end
    end
  end

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
