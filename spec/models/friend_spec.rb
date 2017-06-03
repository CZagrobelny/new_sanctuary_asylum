require 'rails_helper'

RSpec.describe Friend, type: :model do
	subject(:friend) { build :friend }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  
  describe 'validations' do

  	context '"no_a_number" is true' do
  		before { friend.no_a_number = true }
  		it { should_not validate_presence_of(:a_number) }
  	end

  	context '"no_a_number" is false' do
  		it { should validate_presence_of(:a_number) }
  		it { should validate_length_of(:a_number).is_at_most(9).is_at_least(8) }
  		it { should validate_numericality_of(:a_number) }
  	end

  end
end