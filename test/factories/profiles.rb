FactoryBot.define do
  factory :profile do
    user { nil }
    first_name { "MyString" }
    last_name { "MyString" }
    phone { "MyString" }
    bio { "MyText" }
    avatar_url { "MyString" }
  end
end
