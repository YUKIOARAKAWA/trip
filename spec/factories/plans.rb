# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
#  factory :admin, class: Plan do
    name "沖縄の旅"
    start_date Date.today
    end_date Date.today + 7.day
    area_id 1
  end
end
