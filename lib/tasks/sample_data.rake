namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    99.times do |n|
      FactoryGirl.create(:user)
      FactoryGirl.create(:product)
    end
  end
end