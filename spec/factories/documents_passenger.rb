FactoryGirl.define do
  factory :documents_passenger, :class => Signature::DocumentsPassenger do
    trip_id {FactoryGirl.create(:trips_passenger).trip_id}
    passenger_id {FactoryGirl.create(:trips_passenger).passenger_id}
    document_id {FactoryGirl.create(:document).id}
    status false
  end

  factory :document_passenger, :class => Signature::DocumentsPassenger do
    trip_id {FactoryGirl.create(:trip).id}
    passenger_id {FactoryGirl.create(:passenger).id}
    document_id {FactoryGirl.create(:document).id}
    status false
  end
end
