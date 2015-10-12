FactoryGirl.define do
  factory :trips_passenger, :class => Signature::TripsPassenger do
    trip_id FactoryGirl.create(:trip).id
    passenger_id FactoryGirl.create(:passenger).id
  end
end
