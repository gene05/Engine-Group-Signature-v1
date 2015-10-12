module Signature
  class DocumentsPassenger < ActiveRecord::Base
    has_many :documents
    has_many :passengers
    has_one :trip

    scope :list_by_page, ->(page, column, direction, passenger, trip) { joins('JOIN documents on documents.id = documents_passengers.document_id').where(passenger_id: passenger.id, trip_id: trip.id).order((column == "title" ? 'documents.title' : 'documents_passengers.'+column)+' '+direction).limit(50)}

    def self.signed_document(trips_passenger, document, signature, typed_id, name, date)
      document_passenger = DocumentsPassenger.where(trip_id: trips_passenger.trip_id, passenger_id: trips_passenger.passenger_id, document_id: document).last
      document_passenger.update(status: true, signature: signature, signed_name: name, signed_date: date) if document_passenger.signature.nil?
      document_passenger.update(typed_id: typed_id) if typed_id
    end

    def self.pending_to_signs(trip_id, passenger_id)
      Document.includes(:documents_passengers).where(documents_passengers: { trip_id: trip_id, passenger_id: passenger_id, status: false })
    end

    def signature_typed
      signature if typed_id
    end

    def signature_draw
      signature unless typed_id
    end

    def signed?
      status
    end

    def document_title
      document.title if document
    end

    def document_content
      document.content if document
    end

    def format_content(passenger)
      document.format_content(passenger) if document
    end

    def format_date
      updated_at.strftime("%d/%m/%Y") if updated_at
    end

    private

    def document
      Document.where(id: document_id).last
    end

  end
end
