FactoryBot.define do
  factory :head_hunter do
    email { Faker::Internet.email }
    password { 'aaaaaaaaaaaaaaaaaaaa' }
  end
end
