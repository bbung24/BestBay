# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_picture do
    name "MyString"
    content_type "MyString"
    image_data ""
  end
end
