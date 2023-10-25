FactoryBot.define do
  factory :table do
    name { SecureRandom.hex(5) }
    record_index { 0 }
    slug { SecureRandom.hex(8) }
  end

  factory :field do
    name { SecureRandom.hex(5) }
    datatype { "Texte" }
    table
    row_order { 1 }
    slug { SecureRandom.hex(8) }
  end

  factory :user do
    name { Faker::Name::first_name }
    email { "#{SecureRandom.hex(4)}@example.org" }
    password { SecureRandom.hex(8) }
    password_confirmation { password }
  end

  factory :value do
    field
    record_index { 1 }
    data { SecureRandom.hex(5) }
    user
  end

  factory :tables_user do
    table
    user
  end
end
