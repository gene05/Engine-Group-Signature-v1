require 'rails_helper'

module Signature
  RSpec.describe "ImportTripPassengers", type: :request do

    before(:each) do
      @trip = Trip.create!(name: "First Title")
      @passenger = Passenger.create!(name: "Example Name", email: "email@example.com")
      @trip_passenger = TripsPassenger.create(trip_id: @trip.id, passenger_id: @passenger.id)
      @name = 'Imported Passenger Name'
      @email = 'email_imported@exmple.com'
      CSV.open("fileTestInt.csv", "wb") do |csv|
        csv << ['Name', 'Email']
        csv << [@name, @email]
      end
      CSV.open("fileTestFieldEmpty.csv", "wb") do |csv|
        csv << ['Name', 'Email']
        csv << ['', @email]
      end
      CSV.open("fileTestEmailWrong.csv", "wb") do |csv|
        csv << ['Name', 'Email']
        csv << [@name, 'email']
      end
      CSV.open("fileTestEmpty.csv", "wb")
      visit signature_trips_path
    end

    describe "Import Passengers", :js => true do
      it "Import document passenger into Trip" do
        click_on 'Add Trip'
        fill_in "trip[name]", :with => "New Trip", :match => :first
        expect(page).to have_content("You have not assigned passengers")
        click_on 'Add Passengers by CSV'
        attach_file('file', File.absolute_path('fileTestInt.csv'))
        click_on 'Import Passengers'
        expect(page).to have_content(@name)
        expect(page).to have_content(@email)
        click_on 'Save Trip'
        expect(page).to have_content("New Trip")
      end
    end

    describe "Not Import Passengers", :js => true do
      it "should not Import document with field empty" do
        click_on 'Add Trip'
        fill_in "trip[name]", :with => "New Trip", :match => :first
        expect(page).to have_content("You have not assigned passengers")
        click_on 'Add Passengers by CSV'
        attach_file('file', File.absolute_path('fileTestFieldEmpty.csv'))
        click_on 'Import Passengers'
        expect(page).to have_content('You have not assigned passengers')
        expect(page).to have_no_content(@email)
      end

      it "should not Import document with field email with wrong format" do
        click_on 'Add Trip'
        fill_in "trip[name]", :with => "New Trip", :match => :first
        expect(page).to have_content("You have not assigned passengers")
        click_on 'Add Passengers by CSV'
        attach_file('file', File.absolute_path('fileTestEmailWrong.csv'))
        click_on 'Import Passengers'
        expect(page).to have_content('You have not assigned passengers')
        expect(page).to have_no_content(@name)
      end

      it "should not Import document empty" do
        click_on 'Add Trip'
        fill_in "trip[name]", :with => "New Trip", :match => :first
        expect(page).to have_content("You have not assigned passengers")
        click_on 'Add Passengers by CSV'
        attach_file('file', File.absolute_path('fileTestEmpty.csv'))
        click_on 'Import Passengers'
        expect(page).to have_content('You have not assigned passengers')
      end
    end

  end
end
