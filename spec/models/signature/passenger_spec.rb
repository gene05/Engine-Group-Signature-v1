require 'rails_helper'

module Signature
  describe Passenger, :type => :model do

    before do
      Passenger.destroy_all
      Trip.destroy_all
      DocumentsPassenger.destroy_all
    end

    let!(:trip) {FactoryGirl.create(:trip_with_passengers)}
    let!(:trip_without_passengers) {FactoryGirl.create(:trip)}
    let!(:documents_passenger) {FactoryGirl.create(:document_passenger)}
    let!(:trip_documents) {Trip.where(id: documents_passenger.trip_id).last}
    let!(:passenger) {Passenger.where(id: documents_passenger.passenger_id).last}

    it "should list the 10 first passengers by the first page" do
      passengers = Passenger.list_by_page(trip, 0, 'created_at', 'asc')
      expect(passengers.count).to eq 2
      passengers.should eq [trip.passengers.first, trip.passengers.last]
    end

    it "should list the 10 first passengers when there is no page" do
      passengers = Passenger.list_by_page(trip, nil, 'created_at', 'asc')
      expect(passengers.count).to eq 2
      passengers.should eq [trip.passengers.first, trip.passengers.last]
    end

    it "should list first 10 passengers if the argument is not a number" do
      passengers = Passenger.list_by_page(trip, "0", 'created_at', 'asc')
      expect(passengers.count).to eq 2
      passengers.should eq [trip.passengers.first, trip.passengers.last]
    end

    it "should list first 10 passengers if the argument is not an integer" do
      passengers = Passenger.list_by_page(trip, -1, 'created_at', 'asc')
      expect(passengers.count).to eq 2
      passengers.should eq [trip.passengers.first, trip.passengers.last]
    end

    it "should get the passengers by a trip" do
      passengers = Passenger.by_trip(trip)
      expect(passengers.count).to eq 2
      passengers.should eq [trip.passengers.first, trip.passengers.last]
    end

    it "should not get if no passengers by a trip" do
      passengers = Passenger.by_trip(trip_without_passengers)
      expect(passengers.count).to eq 0
      passengers.should eq []
    end

    it "should return the count documents sent by passenger" do
      expect(passenger.count_documents_sent(trip_documents)).to eql 1
    end

    it "should returns sent documents by trip have been signed" do
      documents_passenger.update(status: true)
      expect(passenger.count_signed_documents(trip_documents)).to eql 1
    end

    it "should return false if they have not signed any documents" do
      expect(passenger.signed_all_documents?(trip_documents)).to eql false
    end

    it "should returns the message count 'No documents sent' if No documents sent" do
      expect(trip.passengers.first.documents_to_sign(trip)).to eql "No documents sent"
    end

    it "should returns the message count 'All documents signed' if they have all signed" do
      documents_passenger.update(status: true)
      expect(passenger.documents_to_sign(trip_documents)).to eql "1 / 1"
    end

  end
end
