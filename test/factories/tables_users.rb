FactoryBot.define do
  factory :table do
    name { SecureRandom.hex(5) }
    record_index { 1 }
    slug { SecureRandom.hex(8) }
  end

  factory :field do
    name { SecureRandom.hex(5) }
    datatype { "Texte" }
    table
    slug { SecureRandom.hex(8) }
  end

  factory :user do
    name { SecureRandom.hex(5) }
    email { "#{SecureRandom.hex(4)}@example.org" }
    password { SecureRandom.hex(8) }
    password_confirmation { password }
  end

  factory :tables_user do
    table
    user
  end
end
