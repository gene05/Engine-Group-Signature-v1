require 'rails_helper'

module Signature
  describe DocumentsPassenger do

    let(:document_passenger) {FactoryGirl.create(:documents_passenger)}
    let(:signature) {"string"}
    let(:typed_id) {1}
    let(:name) {'Passenger set Name'}
    let(:date) {'05/10/15'}
    let(:trip) {FactoryGirl.create(:trip)}
    let(:passenger) {FactoryGirl.create(:passenger)}

    it "should signed document by a passenger" do
      trip_passenger = TripsPassenger.where(trip_id: document_passenger.trip_id, passenger_id: document_passenger.passenger_id).last
      expect(document_passenger.signed?).to eql false

      DocumentsPassenger.signed_document(trip_passenger, document_passenger.document_id, signature, typed_id, name, date)

      updated_document_passenger = DocumentsPassenger.find(document_passenger.id)
      expect(updated_document_passenger.signed?).to eql true
      expect(updated_document_passenger.signature).to eql signature
    end

    it "should if is signed the document of the passenger" do
      trip_passenger = TripsPassenger.where(trip_id: document_passenger.trip_id, passenger_id: document_passenger.passenger_id).last
      expect(document_passenger.signed?).to eql false
      DocumentsPassenger.signed_document(trip_passenger, document_passenger.document_id, signature, typed_id, name, date)
      updated_document_passenger = DocumentsPassenger.find(document_passenger.id)

      expect(updated_document_passenger.signed?).to eql true
    end

    it "should return the title document of the passenger" do
      trip_passenger = TripsPassenger.where(trip_id: document_passenger.trip_id, passenger_id: document_passenger.passenger_id).last
      document = Document.find(document_passenger.document_id)
      expect(document_passenger.document_title).to eql document.title
    end

    it "should return the content document of the passenger" do
      trip_passenger = TripsPassenger.where(trip_id: document_passenger.trip_id, passenger_id: document_passenger.passenger_id).last
      document = Document.find(document_passenger.document_id)
      expect(document_passenger.document_content).to eql document.content
    end

    it "should return the documents not sign of a passenger in a trip" do
      document = Document.find(document_passenger.document_id)
      expect(DocumentsPassenger.pending_to_signs(document_passenger.trip_id, document_passenger.passenger_id).first).to eql document
    end

    it "should not return the documents not sign of a passenger if not have a trip" do
      expect(DocumentsPassenger.pending_to_signs(trip.id, passenger.id).count).to eql 0
    end

    it "should not return the documents of a passenger in a trip if they have not been signed" do
      document_passenger.update(status: true)
      expect(DocumentsPassenger.pending_to_signs(document_passenger.trip_id, document_passenger.passenger_id).count).to eql 0
    end

  end
end
