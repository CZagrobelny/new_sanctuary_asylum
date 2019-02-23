FactoryBot.define do
  factory :draft do
    association :friend
    association :application
    pdf_draft { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'images', 'nsc_logo.png'), 'image/jpeg') }
    status { 'in_progress' }
  end
end
