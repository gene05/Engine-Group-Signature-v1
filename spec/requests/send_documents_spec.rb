require 'rails_helper'

module Signature
  RSpec.describe "SendDocuments", type: :request do

    before(:each) do
      @document = Document.create!(title: "First Title", content: "My content")
      @trip = Trip.create!(name: "First Title")
      @passenger = Passenger.create!(name: "Name", email: "email@example.com")
      @trip_passenger = TripsPassenger.create(trip_id: @trip.id, passenger_id: @passenger.id)
      visit passengers_path(@trip.id)
    end

    describe "GET /signature/signatures/trip/:trip_id/passengers" do
      it "list passengers" do
        expect(page).to have_content('Trips > Passengers')
        expect(page).to have_content(@passenger.name)
      end
    end

    describe "POST send_documents", :js => true do
      it "Send Documents" do
        find("#btn-send-documents").click
        expect(page).to have_content('Send Documents')
        find(".table-column#check-send-document-#{@document.id} input[type=checkbox]").set(true)
        click_on "Send Documents"
        expect(ActionMailer::Base.deliveries.last.to).to include(@passenger.email)
        expect(page).to have_content('0 / 1')
      end
    end

  end
end
