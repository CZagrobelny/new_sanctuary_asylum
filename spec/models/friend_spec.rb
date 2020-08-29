require 'rails_helper'

RSpec.describe Friend, type: :model do
	subject(:friend) { build :friend }

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
    let!(:friend) { create :friend }
    let!(:detained_friend) { create :friend, status: 'in_detention' }

    context 'default scope' do
      it 'should include all friends' do
        friends = Friend.all
        expect(friends.size).to eq(2)
        expect(friends.include?(friend)).to eq(true)
        expect(friends.include?(detained_friend)).to eq(true)
      end
    end

    context '.detained scope' do
      it 'should include only detained friends' do
        friends = Friend.detained.all
        expect(friends.size).to eq(1)
        expect(friends).to include(detained_friend)
        expect(friends).to_not include(friend)
      end
    end
  end

  describe '#filter_a_number' do
    let(:friend) { create :friend }

    it 'returns the friend with the a number' do
      expect(Friend.filter_a_number(friend.a_number)).to eq [friend]
    end
  end

  describe '#filter_detained' do
    let(:detained_friend) { create :friend, status: 'in_detention' }
    let(:friend) { create :friend }

    it 'returns the friend that is in detention if 1' do
      expect(Friend.filter_detained(1)).to eq [detained_friend]
    end

    it 'returns all friends if not 1' do
      expect(Friend.filter_detained(0)).to eq [detained_friend, friend]
    end
  end

  describe '#filter_has_a_lawyer' do
    let!(:friend_with_lawyer) { create :friend, has_a_lawyer: true, lawyer_name: 'Susan Q. Example' }
    let!(:friend_without_lawyer) { create :friend, has_a_lawyer: false }

    it 'returns the friend with a lawyer if 1' do
      expect(Friend.filter_has_a_lawyer(1)).to contain_exactly(friend_with_lawyer)
    end

    it 'returns all friends if not 1' do
      expect(Friend.filter_has_a_lawyer(0)).to contain_exactly(friend_with_lawyer, friend_without_lawyer)
    end
  end

  describe '#filter_first_name' do
    let(:friend) { create :friend, first_name: "Cat"}

    it 'returns the friend with the first name' do
      expect(Friend.filter_first_name(friend.first_name)).to eq [friend]
    end
  end

  describe '#with_last_name' do
    let(:friend) { create :friend, last_name: "Power" }

    it 'returns the friend with the last name' do
      expect(Friend.filter_last_name(friend.last_name)).to eq [friend]
    end
  end

  describe '#filter_asylum_application_deadline_ending_after' do
    let(:friend) { create :friend, date_of_entry: Time.now - 1.week }

    context 'the filter is before the friend\'s deadline' do
      let(:date) { friend.date_of_entry - 1.year }
      let(:safe_buffer_date) { ActiveSupport::SafeBuffer.new(date.to_s) }

      it 'returns the friend' do
        expect(Friend.filter_asylum_application_deadline_ending_after(safe_buffer_date))
          .to eq [friend]
      end
    end

    context 'the filter is after the friend\'s deadline' do
      let(:date) { friend.date_of_entry + 1.year + 1.day }
      let(:safe_buffer_date) { ActiveSupport::SafeBuffer.new(date.to_s) }

      it 'doesn\'t return the friend' do
        expect(Friend.filter_asylum_application_deadline_ending_after(safe_buffer_date))
          .to eq []
      end
    end
  end

  describe '#filter_asylum_application_deadline_ending_before' do
    let(:friend) { create :friend, date_of_entry: Time.now - 1.week }
    let(:safe_buffer_date) { ActiveSupport::SafeBuffer.new(date.to_s) }

    context 'the filter is before the friend\'s deadline' do
      let(:date) { friend.date_of_entry - 1.year }

      it 'doesn\'t return the friend' do
        expect(Friend.filter_asylum_application_deadline_ending_before(safe_buffer_date))
          .to eq []
      end
    end

    context 'the filter is after the friend\'s deadline' do
      let(:date) { friend.date_of_entry + 1.year }

      it 'returns the friend' do
        expect(Friend.filter_asylum_application_deadline_ending_before(safe_buffer_date))
          .to eq [friend]
      end
    end
  end

  describe '#filter_judge_imposed_deadline_ending_after' do
    let(:friend) { create :friend, judge_imposed_i589_deadline: 2.months.from_now }
    let(:safe_buffer_date) { ActiveSupport::SafeBuffer.new(date.to_s) }

    context 'the filter is before the friend\'s deadline' do
      let(:date) { friend.judge_imposed_i589_deadline - 1.week }

      it 'returns the friend' do
        expect(Friend.filter_judge_imposed_deadline_ending_after(safe_buffer_date))
          .to contain_exactly friend
      end
    end

    context 'the filter is after the friend\'s deadline' do
      let(:date) { friend.judge_imposed_i589_deadline + 1.week }

      it 'doesn\'t return the friend' do
        expect(Friend.filter_judge_imposed_deadline_ending_after(safe_buffer_date))
          .to be_empty
      end
    end
  end

  describe '#filter_judge_imposed_deadline_ending_before' do
    let(:friend) { create :friend, judge_imposed_i589_deadline: 2.months.from_now }
    let(:safe_buffer_date) { ActiveSupport::SafeBuffer.new(date.to_s) }

    context 'the filter is before the friend\'s deadline' do
      let(:date) { friend.judge_imposed_i589_deadline - 1.week }

      it 'doesn\'t return the friend' do
        expect(Friend.filter_judge_imposed_deadline_ending_before(safe_buffer_date))
          .to be_empty
      end
    end

    context 'the filter is after the friend\'s deadline' do
      let(:date) { friend.judge_imposed_i589_deadline + 1.week }

      it 'returns the friend' do
        expect(Friend.filter_judge_imposed_deadline_ending_before(safe_buffer_date))
          .to contain_exactly friend
      end
    end
  end

  describe '#filter_created_after' do
    let(:friend) { create :friend }
    let(:safe_buffer_date) { ActiveSupport::SafeBuffer.new(date.to_s) }

    context 'the filter is for before the friend was created' do
      let(:date) { friend.created_at }

      it 'returns the friend' do
        expect(Friend.filter_created_after(safe_buffer_date)).to eq [friend]
      end
    end

    context 'the filter is for after the friend was created' do
      let(:date) { friend.created_at + 1.year }

      it 'doesn\'t return the friend' do
        expect(Friend.filter_created_after(safe_buffer_date)).to eq []
      end
    end

  end
end
