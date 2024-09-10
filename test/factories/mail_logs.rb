FactoryBot.define do
  factory :mail_log do
    to { "MyString" }
    subject { "MyString" }
    message_id { "MyString" }
    user { nil }
  end
end
