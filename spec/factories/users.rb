# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com" }
    sequence(:password) { |n| "password#{n}" }
    sequence(:password_confirmation) { |n| "password#{n}" }
    sequence(:first_name) { |n| "Person_first_#{n}" }
    sequence(:last_name) { |n| "Person_last_#{n}" }
  end
end
