require 'rails_helper'

RSpec.describe Friend, type: :model do
	subject(:friend) { build :friend }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:community_id) }

  describe 'validations' do

  	context 'no_a_number is true' do
  		before { friend.no_a_number = true }
  		it { should_not validate_presence_of(:a_number) }
  	end

  	context 'no_a_number is false' do
  		it { should validate_presence_of(:a_number) }
  		it { should validate_length_of(:a_number).is_at_most(9).is_at_least(8) }
  		it { should validate_numericality_of(:a_number) }
  	end

  	context 'date_of_birth is invalid' do
  		before { friend.date_of_birth = '13/11/2012' }
  		it 'should display error' do
  			friend.save

  		end
    end

    context 'zip_code is invalid if not 5 characters' do
     it {should validate_length_of(:zip_code).is_equal_to(5)}
    end

    context 'zip_code is invalid if not a number' do
      it { should validate_numericality_of(:zip_code) }
    end
  end

  describe '#destroy' do
    let!(:friend) { create :friend }

    it 'is deleted' do
      expect{ friend.destroy }.to change{ Friend.count }
    end

    context 'has an associated Activity' do
      before { create :activity, friend: friend }
      it 'is not deleted' do
        expect{ friend.destroy }.not_to change{ Friend.count }
      end
    end

    context 'has an associated Application Draft' do
      before { create :draft, friend: friend }
      it 'is not deleted' do
        expect{ friend.destroy }.not_to change{ Friend.count }
      end
    end
  end

  describe "#grouped_drafts" do
    it "returns an array of grouped drafts" do
      expect(friend.grouped_drafts).to eq ""
    end
  end

  describe 'detained friends' do
    let!(:currently_detained_friend) { create :detained_friend }
    let!(:never_detained_friend) { create :friend }
    let!(:previously_detained_friend) do
      create(:detained_friend).tap do |friend|
        friend.detentions.first.update(date_released: 1.week.ago)
      end
    end

    context 'default scope' do
      it 'should include all friends' do
        friends = Friend.all
        expect(friends.size).to eq(3)
        expect(friends.include?(currently_detained_friend)).to eq(true)
        expect(friends.include?(never_detained_friend)).to eq(true)
        expect(friends.include?(previously_detained_friend)).to eq(true)
      end
    end

    context '.detained scope' do
      it 'should include only currently detained friends' do
        friends = Friend.detained.all
        expect(friends.size).to eq(1)
        expect(friends.include?(currently_detained_friend)).to eq(true)
        expect(friends.include?(never_detained_friend)).to eq(false)
        expect(friends.include?(previously_detained_friend)).to eq(false)
      end
    end
  end
end
