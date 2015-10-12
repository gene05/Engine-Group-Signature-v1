require_dependency "signature/application_controller"

module Signature
  class SignaturesController < ApplicationController
    before_action :set_send_documents, only: [:passengers]
    before_action :set_trip, only: [:passengers, :send_documents, :signature_check]
    before_action :set_passenger, only: [:signature_check]
    before_action :set_document_signed, only: [:document_signed, :download_document_signed]
    before_action :set_messages, only: [:passengers, :trips]

    def trips
      @trips = Trip.list_with_passengers_by_page(page, order, direction)
      if params[:import]
        @passengers = flash[:passengers]
        @trip_name = flash[:trip_name]
        @number_row_with_error = flash[:number_row_with_error] if params[:error] == "row"
      end
    end

    def passengers
      @passengers = Passenger.list_by_page(@trip, page, order, direction)
    end

    def set_send_documents
      @documents = Document.list_by_page(0, 'created_at', 'desc')
    end

    def signature_check
      @check_documents = DocumentsPassenger.list_by_page(page, order, direction, @passenger, @trip)
    end

    def send_documents
      @document_delivery_manager = DocumentDeliveryManager.new(@trip)
      @document_delivery_manager.prepare_shipping(params[:documents_ids])
      redirect_to passengers_path(@trip_id, {sent: true})
    end

    def document_signed
    end

    def download_document_signed
    end

    private

    def set_trip
      @trip_id = params[:trip_id]
      @trip = Trip.where(id: @trip_id).last
    end

    def set_passenger
      @passenger_id = params[:passenger_id]
      @passenger = Passenger.where(id: @passenger_id).last
    end

    def set_document_signed
      @document_signed = DocumentsPassenger.where(id: params[:id]).last
      @passenger = Passenger.where(id: @document_signed.passenger_id).last
    end

    def set_messages
      flash[:notice] = message unless flash[:notice]
    end

    def message
      if params[:sent]
        "The documents have been sent successfully!"
      elsif params[:success] == 'updated'
        params[:action].singularize.titleize+' successfully updated'
      elsif params[:success] == 'added'
        params[:action].singularize.titleize+' successfully added'
      end
    end

  end
end
