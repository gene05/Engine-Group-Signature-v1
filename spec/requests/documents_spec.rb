require 'rails_helper'

module Signature
  RSpec.describe "Documents", type: :request do

    before(:each) do
      @document = Document.create!(title: "First Title", content: "My content")
      visit signature_documents_path
    end

    describe "GET /documents" do
      it "list documents" do
        expect(page).to have_content("First Title")
      end

      it "download a document" do
        find("#download-document-#{@document.id}").click
        expect(page.response_headers['Content-Type']).to eq "application/pdf"
      end
    end

    describe "POST /document" do
      it "add a document", :js => true do
        click_on 'Add Document'
        fill_in "document[title]", :with => "My Document", :match => :first
        page.execute_script("$('#new-document-popup div.note-editable').text('My Document Content');")
        click_on 'Save'
        expect(page).to have_content("My Document")
      end

      it "if the title field is empty, no add a document", :js => true do
        click_on 'Add Document'
        page.execute_script("$('#new-document-popup div.note-editable').text('My Document Content');")
        click_on 'Save'
        expect(page).to have_no_content("My Document Title 2")
      end

      it "if the content field is empty, no add a document", :js => true do
        click_on 'Add Document'
        fill_in "document[title]", :with => "My Document Title 2", :match => :first
        click_on 'Save'
        expect(page).to have_no_content("My Document Title 2")
      end
    end

    describe "PUT /document" do
      it "edit a document", :js => true do
        find("#edit-document-#{@document.id}").click
        fill_in "document[title]", :with => "First Title Edited", :match => :first
        find("#edit-document-popup #btn-add-document").click
        expect(page).to have_content("First Title Edited")
      end
    end

    describe "GET /document" do
      it "show a document", :js => true do
        find("#show-document-#{@document.id}").click
        expect(page).to have_content("#{@document.title}")
        expect(page).to have_content("#{@document.content}")
      end
    end

  end
end
