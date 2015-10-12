module Signature
  class Passenger < ActiveRecord::Base
    has_and_belongs_to_many :trips, :join_table => 'trips_passengers'

    scope :list_by_name, ->{by_trip(@trip).order('passengers.'+@column+' '+@direction).limit(50)}
    scope :list, ->(page, column, direction) {order(column+' '+direction)}
    scope :list_by_page, ->(trip, page, column, direction) {by_trip(trip).order(column+' '+direction).limit(50)}

    def self.by_trip(trip)
      Passenger.joins("JOIN trips_passengers on passengers.id = trips_passengers.passenger_id").where("trips_passengers.trip_id='#{trip.id}'")
    end

    def self.list_by_page(trip, page, column, direction)
      set_params(trip, page, column, direction)
      @manager_order_status = ManagerOrderStatus.new(Passenger, column, direction)
      @manager_order_status.list_method
    end

    def self.all_by_status
      joins('left join documents_passengers on documents_passengers.passenger_id=passengers.id').group('documents_passengers.trip_id, passengers.id').order(@column+' '+@direction+', passengers.id').limit(10).offset(@page).where('documents_passengers.trip_id=?', @trip.id)
    end

    def count_documents_sent(trip)
      trip.documents_sent.where(passenger_id: id).count
    end

    def count_signed_documents(trip)
      trip.documents_sent.where(status: true, passenger_id: id).count
    end

    def signed_all_documents?(trip)
      count_documents_sent(trip) == count_signed_documents(trip)
    end

    def documents_to_sign(trip)
      if count_documents_sent(trip) == 0
        "No documents sent"
      else
        count_signed_documents(trip).to_s+" / "+count_documents_sent(trip).to_s
      end
    end

    def format_date
      updated_at.strftime("%d/%m/%Y") if updated_at
    end
    
    private

    def self.set_params(trip, page, column, direction)
      @trip = trip
      @page = page && page.to_i>0 ? page*10 : 0
      @column = column == "number" ? 'count(documents_passengers.status)' : column
      @direction = direction
    end
    
  end  
end
