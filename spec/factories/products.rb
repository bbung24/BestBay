# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:title) { |n| "Product #{n}" }
    sequence(:condition) { |n| "Product_condition_#{n}" }
    sequence(:price) { |n| n }
    sequence(:detail) { |n| "product_detail_#{n}" }
    sequence(:deadline) { DateTime.current + 13.hours }
    sequence(:keywords) { |n| "product_keywords_#{n}" }
    user
  end
end
