FactoryBot.define do
  factory :user do
    email { "John@example.com" }
    first_name { "John" }
    last_name  { "Doe" }
    password  { "JohnDoe" }
    category { "ad_space_provider" }
  end
end