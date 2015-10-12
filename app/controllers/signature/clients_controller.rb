require_dependency "signature/application_controller"

module Signature
  class ClientsController < ApplicationController
    before_action :validate_passenger, only: [:sign_next_document]

    def sign_document
    end

    def finish_sign
    end

    def sign_next_document
    end

    def passenger_message_error
    end

    def validate_passenger
      @trips_passenger = TripsPassenger.where(:hashed_id => params[:reference]).last
      if @trips_passenger
        signing_document if params[:action] == "sign_next_document"
        show_document_to_sign
      else
        redirect_to passenger_message_error_path
      end
    end

    private

    def show_document_to_sign
      set_documents
      if @count_unsigned_documents > 0
        render :sign_document
      else
        render :finish_sign
      end
    end

    def set_documents
      @unsigned_documents = DocumentsPassenger.pending_to_signs(@trips_passenger.trip_id, @trips_passenger.passenger_id)
      @count_unsigned_documents = @unsigned_documents.count
      @reference = params[:reference]
      set_passenger
    end

    def signing_document
      if validate_checked? && validate_signature?
        signature = params[:output].blank? ? params[:typed] : params[:output]
        DocumentsPassenger.signed_document(@trips_passenger, params[:document_id], signature, params[:typed_id], params[:name], params[:date])
      else
        message_validations
      end
    end

    def message_validations
      if !validate_checked?
        @message ='You must accept all terms and conditions'
      elsif !validate_signature?
        @message ='You must sign the document'
      end
    end

    def validate_checked?
      params[:accepted] == 'yes'
    end

    def validate_signature?
      !params[:output].blank? || !params[:typed].blank?
    end

    def set_passenger
      @passenger = Passenger.where(id: @trips_passenger.passenger_id).last
      @name = params[:name] || @passenger.name
      @date = params[:date]
      @typed = params[:typed]
      @output = params[:output]
      @typed_id = params[:typed_id]
    end

  end
end
