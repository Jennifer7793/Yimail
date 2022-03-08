namespace :db do
  desc "產出垃圾信件"
  task :spam_letters => :environment do
    u = User.random
    10.times do |i|
      u.letters.create(sender: Faker::FunnyName.name,
                       content: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4),
                       created_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :short))
    end
  end
end 