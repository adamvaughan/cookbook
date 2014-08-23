FactoryGirl.define do
  factory :plan do
    month { Date.today.month }
    year { Date.today.year }
  end
end
