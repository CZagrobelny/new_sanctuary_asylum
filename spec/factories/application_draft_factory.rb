FactoryGirl.define do
  factory :application_draft do
    association :friend
    pdf_draft { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'images', 'nsc_logo.png'), 'image/jpeg') }
  end
end