module Signature
  class ManagerImportPassengers
    attr_accessor :passengers
    attr_accessor :number_row_with_error
    attr_accessor :number_rows

    def initialize(trip_id, previous_passengers_ids)
      @passengers = []
      @number_row_with_error = []
      @previous_passengers_ids = previous_passengers_ids
      @trip_id = trip_id
      set_previous_passengers if previous_passengers_ids
    end

    def import(file)
      CSV.foreach(file.path, headers: true) do |row|
        @number_rows = $.
        add_passengers_to_show(row[0], row[1], row)
      end
    end

    private

    def add_passengers_to_show(name, email, row)
      if name.blank? || email.blank?
        @number_row_with_error << (($.)-1)
      else
        validate_fields(name, email, row)
      end
    end

    def validate_fields(name, email, row)
      if isEmail?(email)
        passenger = Passenger.where(name: name.titleize, email: email.downcase).first_or_create
        TripsPassenger.where(passenger_id: passenger.id, trip_id: @trip_id).first_or_create if @trip_id
        @passengers << passenger if @passengers.exclude?(passenger)
      else
        @number_row_with_error << (($.)-1)
      end
    end

    def isEmail?(string)
      string.match(/[a-zA-Z0-9._%]@(?:[a-zA-Z0-9]+\.)[a-zA-Z]{2,4}/)
    end

    def set_previous_passengers
      @previous_passengers_ids.each do |previous_passenger_id|
        passenger = Passenger.where(id: previous_passenger_id).last if previous_passenger_id
        @passengers << passenger if passenger
      end
    end

    def trip
      Trip.where(id: @trip_id).last
    end

  end
end