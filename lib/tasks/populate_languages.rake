LANGUAGES = ["Arabic", "Bengali", "English", "Garifuna", "German", "German", "Gujarati", "Hindi", "Italian", "Japenese", "Javanese", "Jin", "Korean", "Malay", "Mandarin", "Marathi", "Pashto", "Persian", "Polish", "Portuguese", "Punjabi", "Russian", "Southern Min", "Spanish", "Tamil", "Telugu", "Thai", "Turkish", "Urdu", "Vietnamese", "Wu", "Yue"] 

desc 'Populate Language table'
task :populate_languages => :environment do
  Language.destroy_all
  LANGUAGES.each do |language|
    Language.create(name: language)
  end
end