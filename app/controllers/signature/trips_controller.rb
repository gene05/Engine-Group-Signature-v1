require_dependency "signature/application_controller"

module Signature
  class TripsController < ApplicationController
    before_action :set_trip, only: [:edit, :update, :destroy]
    before_action :set_passengers, only: [:index]
    before_action :set_passengers_trip, only: [:edit]

    def index
      @trips = Trip.list_by_page(page, order, direction)
    end

    def new
      @trip = Trip.new
    end

    def edit
      if @trip
        render :json => { status: true, trip: @trip, passengers: @passengers_trip}
      else
        render :json => { status: false}
      end
    end

    def create
      @trip = Trip.new(trip_params)
      if @trip.save
        trip_passengers
        render :json => { status: true, notice: 'Trip was successfully created.', trip: @trip}
      else
        render :json => { status: false}
      end
    end

    def update
      @trip.update(trip_params)
      if @trip.save
        trip_passengers
        render :json => { status: true, notice: 'Trip was successfully updated.', trip: @trip}
      else
        render :json => { status: false}
      end
    end

    def destroy
      @trip.destroy
      flash[:notice] = 'Trip was successfully destroyed.'
      redirect_to trips_url
    end

    private
      def set_trip
        @trip = Trip.find(params[:id])
      end

      def trip_params
        params.require(:trip).permit(:name)
      end

      def set_passengers
        @passengers = Passenger.list(0, 'updated_at', 'desc')
      end

      def trip_passengers
        params[:passengers_ids].each do |passenger_id|
          TripsPassenger.where(trip_id: @trip.id, passenger_id: passenger_id).first_or_create
        end
      end

      def set_passengers_trip
        @passengers_trip = Passenger.by_trip(@trip)
      end

  end
end
