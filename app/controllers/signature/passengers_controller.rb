require_dependency "signature/application_controller"

module Signature
  class PassengersController < ApplicationController
    before_action :set_passenger, only: [:destroy]

    def create
      @passenger = Passenger.create(name: params[:name], email: params[:email])
      if @passenger.save
        add_trip_passenger unless params[:trip_id].blank?
        render :json => { status: true, notice: 'Passenger was successfully added.', passenger: @passenger}
      else
        render :json => { status: false}
      end
    end

    def import
      @import_passengers = ManagerImportPassengers.new(params[:id], params[:previous_passengers_ids])
      validate_format_import
      flash[:passengers] = @import_passengers.passengers
      flash[:trip_name] = params[:import_trip]
      redirect_to signature_trips_path(page: params[:page], id: params[:id], import: @import_status, error: @error)
    end

    def validate_format_import
      if params[:file] && params[:file].content_type=='text/csv'
        @import_passengers.import(params[:file])
        @number_row_with_error = @import_passengers.number_row_with_error
        @number_rows = @import_passengers.number_rows
        validate_import
      else
        @error = "format"
        @import_status = false
      end
    end

    def validate_import
      if @number_row_with_error.count > 0
        @error = "row"
        flash[:number_row_with_error] = @number_row_with_error
        @import_status = false
      else
        @import_status = @number_rows ? true : false
        @error = "empty" unless @number_rows
      end
    end

    def destroy
      destroy_trip_passenger if params[:trip_id]
      @passenger.destroy if trips_with_passenger.count==0
      render :json => { status: true, notice: 'Passenger was successfully destroyed.'}
    end

    private

    def add_trip_passenger
      TripsPassenger.create(passenger_id: @passenger.id, trip_id: params[:trip_id])
    end

    def set_passenger
      @passenger = Passenger.find(params[:id])
    end

    def trips_with_passenger
      TripsPassenger.where(passenger_id: params[:id])
    end

    def destroy_trip_passenger
      trip_passenger = trips_with_passenger.where(trip_id: params[:trip_id]).last
      trip_passenger.destroy if trip_passenger
    end

  end
end
