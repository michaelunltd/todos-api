FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence(5) }
    body { Faker::Lorem.paragraph(3) }
  end
end
