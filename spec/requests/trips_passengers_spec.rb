require 'rails_helper'

module Signature

  RSpec.describe "TripsPassengers", type: :request do

    before(:each) do
      @first_trip = Trip.create!(name: "First Trip")
      @first_passenger = Passenger.create!(name: "Passenger Name", email: "example@email.com")
      @first_trip_passenger = TripsPassenger.create(trip_id: @first_trip.id, passenger_id: @first_passenger.id)
      visit signature_trips_path
    end

    describe "GET /trips" do
      it "list documents" do
        expect(page).to have_content(@first_trip.name)
      end
    end

    describe "POST /trips" do
      it "add a trip with passenger", :js => true do
        click_on 'Add Trip'
        fill_in "trip[name]", :with => "New Trip", :match => :first
        expect(page).to have_content("You have not assigned passengers")
        click_on 'Add Passenger'
        fill_in "name", :with => "New Passenger", :match => :first
        fill_in "email", :with => "example@email.com", :match => :first
        click_on 'Save Passenger'
        expect(page).to have_content("example@email.com")
        click_on 'Save Trip'
        expect(page).to have_content("New Trip")
      end
    end

    describe "PUT /trips" do
      it "update a trip with passenger", :js => true do
        find("#body-group-signature .trip-#{@first_trip.id}").click
        find("#body-group-signature #edit-trip-popup #trip_name").set("Trip Edited")
        expect(page).to have_content(@first_passenger.name)
        click_on 'Add Passenger'
        find("#body-group-signature #edit-trip-popup .signature-section-form-passengers #name").set("Other Passenger")
        find("#body-group-signature #edit-trip-popup .signature-section-form-passengers #email").set("example@email.com")
        click_on 'Save Passenger'
        expect(page).to have_content("Other Passenger")
        click_on 'Save Edit Trip'
        expect(page).to have_content("Trip Edited")
      end
    end

    describe "DELETE passengers trip" do
      it "should remove a passenger assigned to a trip", :js => true do
        find("#body-group-signature .trip-#{@first_trip.id}").click
        expect(page).to have_content(@first_passenger.name)
        expect(page).to have_content(@first_passenger.email)
        find("#body-group-signature #edit-trip-popup a.signature-icon[data-id='#{@first_passenger.id}']").click
        expect(page).to have_content("Are you sure you want to delete the passenger?")
        page.has_selector?('#body-group-signature button.ply-ok')
        find('#body-group-signature .ply-inside').click
        find('#body-group-signature button.ply-ok').click
        expect(page).to have_no_content(@first_passenger.name)
        expect(page).to have_no_content(@first_passenger.email)
        expect(page).to have_content("You have not assigned passengers")
      end
    end

    describe "DELETE /trips" do
      it "should remove a trip", :js => true do
        expect(page).to have_content(@first_trip.name)
        find("#body-group-signature .delete-trip-#{@first_trip.id}").click
        expect(page).to have_content("Are you sure you want to delete the trip?")
        page.has_selector?('#body-group-signature button.ply-ok')
        find('#body-group-signature .ply-inside').click
        find('#body-group-signature .ply-footer').click
        find('#body-group-signature button.ply-ok').click
        expect(page).to have_no_content(@first_trip.name)
      end
    end

  end
end
