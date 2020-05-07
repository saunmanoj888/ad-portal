FactoryBot.define do
  factory :org_booking do
    status { "pending" }
    rent_amount { 5000 }
    start_time  { Date.today }
    end_time  { Date.today + 5 }
  end
end