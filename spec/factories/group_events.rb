FactoryBot.define do
  factory :group_event do
    association :user, factory: :user
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    zipcode { '88898' }
    status { 'Draft' }
    deleted { false }
  end
end
