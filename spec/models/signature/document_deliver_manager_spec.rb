require 'rails_helper'

module Signature
  describe DocumentDeliveryManager do

    let(:trip) {FactoryGirl.create(:trip_with_passengers)}
    let(:document) {FactoryGirl.create(:document)}
    let(:other_passenger) {FactoryGirl.create(:passenger)}

    it "should prepare the shipping" do
      deliver_manager = DocumentDeliveryManager.new(trip)
      deliver_manager.prepare_shipping([document.id])

      expect(DocumentsPassenger.count).to eq 2
      doc1, doc2 = DocumentsPassenger.all
      expect(doc1.document_id).to(eql(document.id))
      expect(doc2.document_id).to(eql(document.id))
      expect(doc1.passenger_id).to(eql(trip.passengers.first.id))
      expect(doc2.passenger_id).to(eql(trip.passengers.last.id))
    end

    it "prepare the shipping, if there are no documents, the documents are not saved to send" do
      deliver_manager = DocumentDeliveryManager.new(trip)
      deliver_manager.prepare_shipping([])
      expect(DocumentsPassenger.count).to eq 0
    end

    it "save sending documents, if the documents have not been created, This should saved" do
      deliver_manager = DocumentDeliveryManager.new(trip)
      deliver_manager.save_sending_documents(trip.passengers.first, [document.id])
      expect(DocumentsPassenger.count).to eq 1
    end

    it "save sending documents, if the documents have been created, This should not saved" do
      deliver_manager = DocumentDeliveryManager.new(trip)
      deliver_manager.save_sending_documents(trip.passengers.first, [document.id])
      first_count = DocumentsPassenger.count

      deliver_manager.save_sending_documents(trip.passengers.first, [document.id])
      expect(DocumentsPassenger.count).to eq first_count
    end

    it "save sending documents, if there are no documents or passengers, this not saved" do
      deliver_manager = DocumentDeliveryManager.new(trip)
      deliver_manager.save_sending_documents(trip.passengers.first, [])
      expect(DocumentsPassenger.count).to eq 0
    end

    it "should sending documents, if exist a passenger on the trip" do
      deliver_manager = DocumentDeliveryManager.new(trip)
      expect { deliver_manager.sending_documents(trip.passengers.first) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "not should sending documents, if not exist a passenger on the trip" do
      deliver_manager = DocumentDeliveryManager.new(trip)
      expect { deliver_manager.sending_documents(other_passenger) }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end

    it "should set the relation between forms and passengers before to send" do
      deliver_manager = DocumentDeliveryManager.new(trip)
      deliver_manager
    end

  end
 end
