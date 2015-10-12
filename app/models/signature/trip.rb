module Signature
  class Trip < ActiveRecord::Base
    has_and_belongs_to_many :passengers, :join_table => 'trips_passengers'
    scope :list_by_name, ->{order(@column+' '+@direction).page(@page).per(10)}
    scope :list_with_passengers_by_page, ->(page, column, direction) {joins('JOIN trips_passengers on trips_passengers.trip_id = trips.id').distinct.order(column+' '+direction).page(page).per(5)}

    def self.list_by_page(page, column, direction)
      set_params(page, column, direction)
      @manager_order_status = ManagerOrderStatus.new(Trip, column, direction)
      @manager_order_status.list_method
    end

    def self.all_by_status
      joins('left join documents_passengers on documents_passengers.trip_id=trips.id').group('trips.id').order(@column+' '+@direction).page(@page).per(5)
    end

    def documents_sent
      DocumentsPassenger.where(trip_id: id)
    end

    def count_documents_sent
      documents_sent.count
    end

    def count_signed_documents
      documents_sent.where(status: true).count
    end

    def count_documents_to_sign
      count_documents_sent-count_signed_documents
    end

    def signed_all_documents?
      count_documents_sent == count_signed_documents
    end

    def documents_to_sign
      if count_documents_sent == 0
        "No documents sent"
      elsif signed_all_documents?
        "All documents signed"
      elsif count_signed_documents < count_documents_sent
        count_documents_to_sign.to_s+'/'+count_documents_sent.to_s+" documents pending to sign"
      end
    end

    def format_date
      updated_at.strftime("%d/%m/%Y") if updated_at
    end
    
    private

    def self.set_params(page, column, direction)
      @page = page
      @column = column == "number" ? 'count(documents_passengers.status)' : column
      @direction = direction
    end

  end
end
