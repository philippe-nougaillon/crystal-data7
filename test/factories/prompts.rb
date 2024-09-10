FactoryBot.define do
  factory :prompt do
    user { nil }
    table { nil }
    query { "MyString" }
    response { "MyString" }
  end
end
