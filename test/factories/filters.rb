FactoryBot.define do
  factory :filter do
    name { SecureRandom.hex(5) }
    table
    slug { SecureRandom.hex(8) }
  end
end
