require 'rails_helper'

module Signature
  RSpec.describe "SigningDocuments", type: :request do

    before(:each) do
      @document = Document.create!(title: "First Title", content: "{{@NAME@}}, My content")
      @trip = Trip.create!(name: "First Title")
      @passenger = Passenger.create!(name: "Example Name", email: "email@example.com")
      @trip_passenger = TripsPassenger.create(trip_id: @trip.id, passenger_id: @passenger.id)
      @docuent_passenger = DocumentsPassenger.create(document_id: @document.id, trip_id: @trip.id, passenger_id: @passenger.id, status: false)
      @invalid_hash = '4521456'
    end

    describe "Signing Documents", :js => true do
      before do
        visit "/d/#{@trip_passenger.hashed_id}"
        expect(page).to have_content("#{@passenger.name.titleize}, My content")
      end

      it "You can sign the document, drawing signed" do
        find("#body-group-signature .client-document-content #accepted").set(true)
        page.evaluate_script("$('#body-group-signature .sigPad input.output').val('[{lx:68,ly:28,mx:68,my:27}]');")
        find("#body-group-signature .document-section-sign").click
        expect(page).to have_content("Sign")
        page.has_selector?('#body-group-signature a.button-sign')
        find('#body-group-signature .ply-inside').click
        find('#body-group-signature .ply-inside .sigPad').click
        find('#body-group-signature a.button-sign').click
        find("#body-group-signature .document-confirm-button").click
        expect(page).to have_content("Thanks for signing the required documents")
      end

      it "You can sign the document, typing name" do
        find("#body-group-signature .client-document-content #accepted").set(true)
        find("#body-group-signature .document-section-sign").click
        expect(page).to have_content("Sign")
        page.has_selector?('#body-group-signature a.button-sign')
        find('#body-group-signature .ply-inside').click
        find('#body-group-signature .ply-inside .sigPad').click
        find('#body-group-signature .ply-inside li.typeIt').click
        find('#body-group-signature a.button-sign').click
        find("#body-group-signature .document-confirm-button").click
        expect(page).to have_content("Thanks for signing the required documents")
      end

      it "Should not move to the next if it does not have the selected check" do
        page.evaluate_script("$('#body-group-signature .sigPad input.output').val('[{lx:68,ly:28,mx:68,my:27}]');")
        find("#body-group-signature .document-section-sign").click
        expect(page).to have_content("Sign")
        page.has_selector?('#body-group-signature a.button-sign')
        find('#body-group-signature .ply-inside').click
        find('#body-group-signature .ply-inside .sigPad').click
        find('#body-group-signature a.button-sign').click
        find("#body-group-signature .document-confirm-button").click
        expect(page).to have_no_content("Thanks for signing the required documents")
      end

      it "Should not move to the next if the field is empty name or date" do
        find("#body-group-signature .client-document-content #accepted").set(true)
        fill_in "name", with: ""
        find("#body-group-signature .client-document-content .document-confirm-button").click
        expect(page).to have_no_content("Thanks for signing the required documents")
      end

      it "You should not move to the next if it has not been signed" do
        find("#body-group-signature .client-document-content #accepted").set(true)
        find("#body-group-signature .client-document-content .document-confirm-button").click
        expect(page).to have_no_content("Thanks for signing the required documents")
      end

    end

    describe "Documents already Signed", :js => true do
      it "You can sign the document, drawing signed" do
        @docuent_passenger.update(signature: '[{lx:68,ly:28,mx:68,my:27}]', status: true)        
        visit "/d/#{@trip_passenger.hashed_id}"
        expect(page).to have_content("Thanks for signing the required documents")
      end
    end

    describe "Wrong link to signature", :js => true do
      it "you can not enter if not correct access" do
        visit "/d/#{@invalid_hash}"
        expect(page).to have_content("Denied access to this view")
        expect(page).to have_content("You can not access this view.")
      end
    end

  end
end
