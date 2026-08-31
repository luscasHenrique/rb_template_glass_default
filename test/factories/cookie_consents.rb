FactoryBot.define do
  factory :cookie_consent do
    user { nil }
    session_hash { "MyString" }
    ip_address { "MyString" }
    analytics_accepted { false }
    marketing_accepted { false }
    necessary_accepted { false }
  end
end
