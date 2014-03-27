# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bad_keyword do
    sequence(:keyword) { |n| "Bad #{n}" }
  end
end
