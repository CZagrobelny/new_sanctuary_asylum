FactoryBot.define do
  factory :access_time_slot do
    start_time { 1.hour.from_now }
    end_time { 3.hours.from_now }
    use { AccessTimeSlot::DATA_ENTRY_USES.sample }
    association :grantor, factory: :user
    association :grantee, factory: :user, role: :data_entry
    association :community
  end
end
