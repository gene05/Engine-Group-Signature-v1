require 'rails_helper'

module Signature
  describe Document, :type => :model do

    before do
     Document.destroy_all
    end

    let!(:document1) {FactoryGirl.create(:document)}
    let!(:document_passenger) {FactoryGirl.create(:document_passenger)}
    let!(:document2) {Document.where(id: document_passenger.document_id).last}
    let!(:passenger2) {Passenger.where(id: document_passenger.passenger_id).last}

    it "should list the 10 first documents by the first page" do
      documents = Document.list_by_page(0, 'title', 'asc')
      expect(documents.count).to eq 2
      documents.should eq [document1, document2]
    end

    it "should list the 10 first documents when there is no page" do
      documents = Document.list_by_page(nil, 'title', 'asc')
      expect(documents.count).to eq 2
      documents.should eq [document1, document2]
    end

    it "should list first 10 documents if the argument is not a number" do
      documents = Document.list_by_page("0", 'title', 'asc')
      expect(documents.count).to eq 2
      documents.should eq [document1, document2]
    end

    it "should list first 10 documents if the argument is not an integer" do
      documents = Document.list_by_page(-1, 'title', 'asc')
      expect(documents.count).to eq 2
      documents.should eq [document1, document2]
    end

    it "should return the format of the update of the document to dd/mm/yy" do
      document = Document.create(updated_at: '2007-11-19T08:37:48-0600')
      document.format_date.should eq '19/11/2007'
    end

    it "should return the format of the content of the document" do
      document2.format_content(passenger2).should eq 'StringContent '+passenger2.name.titleize
    end

    it "should return the name passenger signer" do
      document2.passenger_name(passenger2).should eq passenger2.name.titleize
    end

  end
end
