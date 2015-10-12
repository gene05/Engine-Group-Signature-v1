require 'rails_helper'

module Signature
  describe ManagerOrderStatus do

    before do
      Passenger.destroy_all
      Trip.destroy_all
      DocumentsPassenger.destroy_all
    end

    let!(:document_passenger1) {FactoryGirl.create(:document_passenger)}
    let!(:document_passenger2) {FactoryGirl.create(:document_passenger)}
    let!(:trip1) {Trip.find(document_passenger1.trip_id)}
    let!(:trip2) {Trip.find(document_passenger2.trip_id)}
    let!(:passenger1) {Passenger.find(document_passenger1.passenger_id)}
    let!(:passenger2) {Passenger.find(document_passenger2.passenger_id)}
    let!(:column1) {'name'}
    let!(:column2) {'number'}
    let!(:direction) {'desc'}
    let!(:page) {0}

    it "should list the trips by first page and order name" do
      Trip.list_by_page(page, column1, direction)
      status_manager = ManagerOrderStatus.new(Trip, column1, direction)
      expect(status_manager.list_method.count).to eq 2
      expect(status_manager.list_method).to eq [trip1, trip2]
    end

    it "should list the passengers by first page and order name" do
      TripsPassenger.create(trip_id: document_passenger1.trip_id, passenger_id: document_passenger1.passenger_id)
      Passenger.list_by_page(trip1, page, column1, direction)
      status_manager = ManagerOrderStatus.new(Passenger, column1, direction)
      expect(status_manager.list_method.count).to eq 1
      expect(status_manager.list_method).to eq [passenger1]
    end

    it "should list the trips by first page and order number" do
      document_passenger2.update(status: true)
      Trip.list_by_page(page, column2, direction)
      status_manager = ManagerOrderStatus.new(Trip, column2, direction)
      expect(status_manager.list_method.count).to eq 2
      expect(status_manager.list_method).to eq [trip2, trip1]
    end

    it "should list the trips with signed documents with true status" do
      document_passenger2.update(status: true)
      Trip.list_by_page(page, column2, direction)
      status_manager = ManagerOrderStatus.new(Trip, column2, direction)
      expect(status_manager.with_status_true).to eq [trip2]
    end

    it "should list the trips with signed documents with false status" do
      document_passenger2.update(status: true)
      Trip.list_by_page(page, column2, direction)
      status_manager = ManagerOrderStatus.new(Trip, column2, direction)
      expect(status_manager.with_status_false).to eq [trip1]
    end

  end
 end
