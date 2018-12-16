FactoryGirl.define do
  factory :release do
    release_form do
      path = Rails.root.join('spec', 'support', 'images', 'nsc_logo.png')
      Rack::Test::UploadedFile.new(path, 'image/jpeg')
    end
    category Release::TYPES.first
  end
end
