require 'rails_helper'

module Signature
  describe Trip, :type => :model do

    before do
      Trip.destroy_all
      DocumentsPassenger.destroy_all
    end

    let!(:trip1) {FactoryGirl.create(:trip)}
    let!(:trip2) {FactoryGirl.create(:trip)}
    let!(:documents_passenger) {FactoryGirl.create(:document_passenger)}
    let!(:trip_documents) {Trip.where(id: documents_passenger.trip_id).last}

    it "should list the 10 first trips by the first page" do
      trips = Trip.list_by_page(0, 'created_at', 'asc')
      expect(trips.count).to eq 3
      trips.should eq [trip1, trip2, trip_documents]
    end

    it "should list the 10 first trips when there is no page" do
      trips = Trip.list_by_page(nil, 'created_at', 'asc')
      expect(trips.count).to eq 3
      trips.should eq [trip1, trip2, trip_documents]
    end

    it "should list first 10 trips if the argument is not a number" do
      trips = Trip.list_by_page("0", 'created_at', 'asc')
      expect(trips.count).to eq 3
      trips.should eq [trip1, trip2, trip_documents]
    end

    it "should list first 10 trips if the argument is not an integer" do
      trips = Trip.list_by_page(-1, 'created_at', 'asc')
      expect(trips.count).to eq 3
      trips.should eq [trip1, trip2, trip_documents]
    end

    it "should list the 10 first trips by the first page and status" do
      trip_documents.update(status: true)
      Trip.list_by_page(0, 'number', 'desc')
      Trip.all_by_status.should eq [trip_documents, trip1, trip2]
    end

    it "should return the documents sent by passenger trip" do
      trip_documents.documents_sent.should eq [documents_passenger]
    end

    it "should return the count documents sent by passenger trip" do
      expect(trip_documents.count_documents_sent).to eql 1
    end

    it "should returns sent documents by trip have been signed" do
      documents_passenger.update(status: true)
      expect(trip_documents.count_signed_documents).to eql 1
    end

    it "should returns sent documents by trip have been not signed" do
      documents_passenger.update(status: true)
      expect(trip_documents.count_documents_to_sign).to eql 0
    end

    it "should return false if they have not signed any documents" do
      expect(trip_documents.signed_all_documents?).to eql false
    end

    it "should returns the message count 'to sign documents' if they have not signed" do
      expect(trip_documents.documents_to_sign).to eql "1/1 documents pending to sign"
    end

    it "should returns the message count 'No documents sent' if No documents sent" do
      expect(trip2.documents_to_sign).to eql "No documents sent"
    end

    it "should returns the message count 'All documents signed' if they have all signed" do
      documents_passenger.update(status: true)
      expect(trip_documents.documents_to_sign).to eql "All documents signed"
    end

  end
end
