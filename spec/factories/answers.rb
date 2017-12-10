FactoryBot.define do
  factory :answer do
    question nil
    body { Faker::Lorem.paragraph(3) }
  end
end
