require 'rails_helper'

module Signature
  describe ManagerImportPassengers do

    before do
      Passenger.destroy_all
      Trip.destroy_all
      TripsPassenger.destroy_all
    end

    let(:name) { 'Passenger Name' }
    let(:email) { 'email@example.com' }
    let(:file) { CSV.open("file.csv", "wb") do |csv|
                    csv << ['Name', 'Email']
                    csv << [name, email]
                  end }
    let(:file_field_empty) { CSV.open("file.csv", "wb") do |csv|
                              csv << ['Name', 'Email']
                              csv << [name, '']
                            end }
    let(:file_wrong_email_format) { CSV.open("file.csv", "wb") do |csv|
                                    csv << ['Name', 'Email']
                                    csv << [name, 'email']
                                  end }
    let(:trip) { FactoryGirl.create(:trip_with_passengers) }

    it "should import passengers by a document csv to a trip" do
      import_passengers = ManagerImportPassengers.new(trip.id, [trip.passengers.first.id, trip.passengers.last.id])
      expect { import_passengers.import(file) }.to change { Passenger.count }.by(1)
      passenger = Passenger.last
      expect(passenger.name).to(eql(name))
      expect(passenger.email).to(eql(email))
    end

    it "should not import passengers if a document has a field empty" do
      import_passengers = ManagerImportPassengers.new(trip.id, [trip.passengers.first.id, trip.passengers.last.id])
      expect { import_passengers.import(file_field_empty) }.not_to change{ Passenger.count }
    end

    it "should not import passengers if a document has a field with wrong email format" do
      import_passengers = ManagerImportPassengers.new(trip.id, [trip.passengers.first.id, trip.passengers.last.id])
      expect { import_passengers.import(file_wrong_email_format) }.not_to change{ Passenger.count }
    end

  end
 end
