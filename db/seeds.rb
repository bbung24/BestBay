# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@user = FactoryGirl.create(:user, email:"iyong@example.com", first_name:"Inho", last_name:"Yong", password:"foooobar", password_confirmation:"foooobar")
FactoryGirl.create(:product, title: "iPhone 5s",condition: "New", price: 800.00 ,detail: "New iPhone 5s Product ! Free Shipping !", deadline:DateTime.current+13.hours, user: @user)


10.times do |n|
  @user = FactoryGirl.create(:user)
  FactoryGirl.create(:product, user: @user)
end


FactoryGirl.create(:bad_keyword, keyword: "drug")
FactoryGirl.create(:bad_keyword, keyword: "weapon")
FactoryGirl.create(:bad_keyword, keyword: "gun")
FactoryGirl.create(:bad_keyword, keyword: "pistol")
FactoryGirl.create(:bad_keyword, keyword: "bad")
