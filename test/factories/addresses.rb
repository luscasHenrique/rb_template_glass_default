FactoryBot.define do
  factory :address do
    addressable { nil }
    zip_code { "MyString" }
    street { "MyString" }
    number { "MyString" }
    complement { "MyString" }
    city { "MyString" }
    state { "MyString" }
  end
end
