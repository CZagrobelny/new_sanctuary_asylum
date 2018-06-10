FactoryGirl.define do
  factory :friend do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    a_number { rand.to_s[2..10] }
    association :community
  end

  factory :detained_friend, parent: :friend do
    after(:create) do |friend|
      location = create(:location)
      friend.detentions.create! location: location, date_detained: 1.month.ago
    end
  end
end