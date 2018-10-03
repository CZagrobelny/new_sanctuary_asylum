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
		let(:friend) { create :friend }
		let(:application1) { create :application, category: 'asylum', friend: friend }
  	let(:application2) { create :application, category: 'foia', friend: friend }
		let!(:draft1) { create :draft, application: application1, friend: friend }
		let!(:draft2) { create :draft, application: application2, friend: friend }

    it "returns an array of grouped drafts" do
			result = [{ :name=>"asylum", :drafts=> [draft1], application: application1 },
 	  	   				{ :name=>"foia", :drafts=> [draft2], application: application2 }]

      expect(friend.reload.grouped_drafts).to match_array(result)
    end
  end

	describe "#name" do
		subject { friend.name }

		it "returns the first name and last name" do
			expected_value = "#{friend.first_name} #{friend.last_name}"

			expect(subject).to eq(expected_value)
		end
	end

	describe "#ethnicity" do
		subject { friend.ethnicity }

		context "is other ethnicity" do
			let(:friend) { create :friend, ethnicity: 'other', other_ethnicity: 'awesome' }

			it "returns the other ethnicity" do
				expect(subject).to eq(friend.other_ethnicity)
			end
		end

		context "is not other ethnicity" do
			let(:friend) { create :friend, ethnicity: 'asian' }

			it "returns the ethnicity" do
				expect(subject).to eq(friend.ethnicity)
			end
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

  describe 'friends with their 1 year asylum application deadlines falling between two future boundaries, inclusive' do
    context '.asylum_deadlines_ending scope' do
      it 'should return only the friends whose deadlines fall within the two boundaries, inclusive' do
        # Lookup boundaries
        deadlines_ending_floor = 2.months.from_now.beginning_of_day
        deadlines_ending_ceiling = deadlines_ending_floor + 1.month

        # date_of_entry fixture data
        earliest_date_of_entry = deadlines_ending_floor - 1.year
        latest_date_of_entry = deadlines_ending_ceiling - 1.year

        within_boundaries = [
          create(:friend, date_of_entry: earliest_date_of_entry), # inclusive (ON the lower boundary)
          create(:friend, date_of_entry: earliest_date_of_entry + 1.day),
          create(:friend, date_of_entry: earliest_date_of_entry + 2.weeks),
          create(:friend, date_of_entry: latest_date_of_entry - 1.day),
          create(:friend, date_of_entry: latest_date_of_entry) # inclusive (ON the upper boundary)
        ]

        outside_boundaries = [
          create(:friend, date_of_entry: earliest_date_of_entry - 1.week),
          create(:friend, date_of_entry: earliest_date_of_entry - 1.day),
          create(:friend, date_of_entry: latest_date_of_entry + 1.day),
          create(:friend, date_of_entry: latest_date_of_entry + 1.week)
        ]

        friends = Friend.asylum_deadlines_ending(deadlines_ending_floor, deadlines_ending_ceiling)
        expect(friends).to eq(within_boundaries)
      end
    end
  end
end
