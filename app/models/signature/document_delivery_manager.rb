module Signature
  class DocumentDeliveryManager
    def initialize(trip)
      @trip = trip
    end

    def prepare_shipping(documents)
      Passenger.by_trip(@trip).each do |passenger|
        save_sending_documents(passenger, documents)
      end
    end

    def save_sending_documents(passenger, documents)
      documents.each do |document|
        check_or_create(passenger, document)
      end
      sending_documents(passenger) if documents.count>0
    end

    def check_or_create(passenger, document)
      document_passenger = DocumentsPassenger.where(trip_id: @trip.id, passenger_id: passenger.id, document_id: document).last
      DocumentsPassenger.create(trip_id: @trip.id, passenger_id: passenger.id, document_id: document, status: false) unless document_passenger
    end

    def sending_documents(passenger)
      trip_passenger = TripsPassenger.where(:passenger_id => passenger.id, :trip_id => @trip.id).last
      UserMailer.send_documents(passenger, trip_passenger.hashed_id).deliver_now if trip_passenger
    end

  end
end
